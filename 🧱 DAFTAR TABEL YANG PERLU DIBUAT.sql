🧱 DAFTAR TABEL YANG PERLU DIBUAT
🔹 1. transactions
Header semua jenis transaksi

Kolom	Tipe	Keterangan
id	BIGINT (PK)	ID transaksi
transaction_type	ENUM	SALE, PURCHASE, TRANSFER, etc
reference_code	VARCHAR	Nomor faktur / referensi
original_transaction_id	BIGINT (FK ke transactions)	Untuk pembatalan
description	TEXT	Catatan
status	ENUM('CONFIRMED','CANCELED')	Status transaksi
date	DATETIME	Tanggal transaksi
created_by	INT	ID user pembuat
created_at	DATETIME	Timestamp
updated_at	DATETIME	Timestamp

🔹 2. transaction_details
Detail produk/barang dalam transaksi

Kolom	Tipe	Keterangan
id	BIGINT PK	ID detail
transaction_id	BIGINT FK	Referensi ke transaksi utama
product_id	INT FK	Produk yang ditransaksikan
warehouse_id	INT	Gudang untuk SALE, PURCHASE, ADJUSTMENT
from_warehouse_id	INT	Untuk TRANSFER (asal)
to_warehouse_id	INT	Untuk TRANSFER (tujuan)
quantity	DECIMAL	Jumlah barang
unit_price	DECIMAL	Harga satuan
discount	DECIMAL	Potongan
total	DECIMAL	Total harga setelah diskon
notes	TEXT	Keterangan tambahan

 3. transaction_payments
Total uang dibayar untuk suatu transaksi

Kolom	Tipe	Keterangan
id	BIGINT PK	ID pembayaran
transaction_id	BIGINT FK	Referensi ke transaksi
total_paid	DECIMAL	Jumlah uang dibayar
change_returned	DECIMAL	Kembalian jika ada
created_at	DATETIME	Waktu bayar

🔹 4. transaction_payment_methods
Rincian metode pembayaran (cash, qris, bank, dll)

Kolom	Tipe	Keterangan
id	BIGINT PK	ID detail metode pembayaran
transaction_payment_id	BIGINT FK	FK ke transaction_payments
method	ENUM	CASH, QRIS, TRANSFER, etc
amount	DECIMAL	Jumlah uang via metode ini
cash_account_id	INT FK	Uang masuk ke akun kas mana

🔹 5. cash_accounts
Daftar akun kas (kas fisik, bank, qris, e-wallet)

Kolom	Tipe	Keterangan
id	INT PK	ID akun kas
name	VARCHAR	Nama akun kas
type	ENUM	CASH, BANK, QRIS, EWALLET
is_active	BOOLEAN	Untuk aktivasi/nonaktifasi


✅ Total: 8 Tabel (5 utama + 3 referensi)
Jenis	Nama Tabel
Utama	transactions
transaction_details
transaction_payments
transaction_payment_methods
cash_accounts
Referensi	products (opsional)
warehouses (opsional)
users (opsional)

-- Tabel transactions
Tabel:
    `cash_account` : Referensi ke mana uang masuk atau keluar
    `ref_gudang` : Referensi ke gudang asal/tujuan untuk transaksi
    `tabel_users` : Referensi ke user yang membuat transaksi
    `tabel_barang` : Referensi ke produk yang ditransaksikan

    `transactions` : Header semua jenis transaksi
    `transaction_details` : Detail produk/barang dalam transaksi
    `transaction_payments` : Total uang dibayar untuk suatu transaksi
    `transaction_payment_methods` : Rincian metode pembayaran (cash, qris, bank, dll)
    `transaction_payment_history` : Riwayat pembayaran untuk transaksi

| Jenis Transaksi      | Tabel yang Terlibat                                                                          |
| -------------------- | -------------------------------------------------------------------------------------------- |
| Penjualan            | `transactions`, `transaction_details`, `transaction_payments`, `transaction_payment_methods` |
| Penjualan Cicilan    | + `transaction_payment_history`                                                              |
| Pembelian            | Sama seperti penjualan                                                                       |
| Transfer Gudang      | `transactions`, `transaction_details` (pakai `from_warehouse_id` dan `to_warehouse_id`)      |
| Penyesuaian Stok     | `transactions`, `transaction_details`                                                        |
| Pembatalan Transaksi | `transactions` (tipe: `CANCEL_SALE`, `CANCEL_PURCHASE`) + referensi ke transaksi awal        |

VIEW laporan transaksi
```
CREATE VIEW view_transaksi AS
SELECT
  DATE(t.date) AS tanggal,
  t.id AS transaksi_id,
  t.reference_code AS kode,
  t.transaction_type AS jenis,
  td.product_id,
  b.namabarang AS nama_produk,
  td.quantity AS jumlah,
  td.unit_price AS harga_satuan,
  td.discount,
  (td.quantity * td.unit_price - td.discount) AS total,
  td.from_warehouse_id AS asal_gudang,
  COALESCE(td.to_warehouse_id, td.warehouse_id) AS tujuan_gudang,
  u.username AS created_by
FROM transactions t
LEFT JOIN transaction_details td ON td.transaction_id = t.id
LEFT JOIN tabel_barang b ON b.idbarang = td.product_id
LEFT JOIN tabel_user u ON u.iduser = t.created_by
WHERE t.status = 'CONFIRMED'
  AND t.date BETWEEN '2025-06-01' AND '2025-06-30'
ORDER BY t.date DESC;

```

VIEW CICILAN
```
SELECT 
  DATE(ph.date) AS tanggal,
  ph.method,
  SUM(ph.amount) AS total_pelunasan
FROM transaction_payment_history ph
JOIN transactions t ON ph.transaction_id = t.id
WHERE t.transaction_type = 'SALE'
  AND t.status = 'CONFIRMED'
GROUP BY DATE(ph.date), ph.method;

```

1. SQL PENJUALAN
```
INSERT INTO transactions 
(transaction_type, reference_code, date, created_by, status, payment_status)
VALUES 
('SALE', 'INV-001', '2025-06-28 14:00:00', 1, 'CONFIRMED', 'PAID');

INSERT INTO transaction_details 
(transaction_id, product_id, warehouse_id, quantity, unit_price, discount, notes)
VALUES 
(1, 30, 1, 2, 25000, 0, 'Penjualan item biasa');

INSERT INTO transaction_payments (transaction_id, total_paid, change_returned)
VALUES (1, 50000, 0);

INSERT INTO transaction_payment_methods
(transaction_payment_id, method, amount, cash_account_id)
VALUES 
(1, 'CASH', 30000, 1),
(1, 'QRIS', 20000, 2);


```
