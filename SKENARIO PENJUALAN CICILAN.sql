SKENARIO PENJUALAN CICILAN
```
INSERT INTO transactions 
(transaction_type, reference_code, date, created_by, status, payment_status)
VALUES ('SALE', 'INV-002', '2025-06-28 15:00:00', 1, 'CONFIRMED', 'PARTIAL');
-- anggap id = 2

INSERT INTO transaction_details 
(transaction_id, product_id, warehouse_id, quantity, unit_price, discount)
VALUES (2, 30, 1, 2, 25000, 0);


INSERT INTO transaction_payments (transaction_id, total_paid, change_returned)
VALUES (2, 30000, 0);
-- anggap id = 2


INSERT INTO transaction_payment_methods
(transaction_payment_id, method, amount, cash_account_id)
VALUES 
(2, 'CASH', 20000, 1),
(2, 'QRIS', 10000, 2);


INSERT INTO transaction_payment_history
(transaction_id, date, amount, method, cash_account_id, notes)
VALUES 
(2, '2025-06-29 10:00:00', 10000, 'TRANSFER', 3, 'Cicilan pertama'),
(2, '2025-07-01 09:00:00', 10000, 'QRIS', 2, 'Cicilan kedua lunas');


SELECT 
  t.id AS transaksi_id,
  SUM(td.quantity * td.unit_price - td.discount) AS total_transaksi,
  COALESCE(p.total_paid, 0) + COALESCE(h.total_cicilan, 0) AS total_dibayar,
  (SUM(td.quantity * td.unit_price - td.discount) - 
   (COALESCE(p.total_paid, 0) + COALESCE(h.total_cicilan, 0))) AS sisa_piutang
FROM transactions t
JOIN transaction_details td ON td.transaction_id = t.id
LEFT JOIN transaction_payments p ON p.transaction_id = t.id
LEFT JOIN (
  SELECT transaction_id, SUM(amount) AS total_cicilan
  FROM transaction_payment_history
  GROUP BY transaction_id
) h ON h.transaction_id = t.id
WHERE t.id = 2
GROUP BY t.id;

```

inputan
[
  {
    "transaction_id": 2,
    "date": "2025-06-29 10:00:00",
    "amount": 10000,
    "method": "TRANSFER",
    "cash_account_id": 3,
    "notes": "Cicilan pertama"
  },
  {
    "transaction_id": 2,
    "date": "2025-07-01 09:00:00",
    "amount": 10000,
    "method": "QRIS",
    "cash_account_id": 2,
    "notes": "Cicilan kedua lunas"
  }
]


reuslt api
{
  "transaction_type": "SALE",
  "reference_code": "INV-002",
  "date": "2025-06-28 15:00:00",
  "created_by": 1,
  "status": "CONFIRMED",
  "payment_status": "PARTIAL",
  "details": [
    {
      "product_id": 30,
      "warehouse_id": 1,
      "quantity": 2,
      "unit_price": 25000,
      "discount": 0
    }
  ],
  "payment": {
    "total_paid": 30000,
    "change_returned": 0,
    "methods": [
      {
        "method": "CASH",
        "amount": 20000,
        "cash_account_id": 1
      },
      {
        "method": "QRIS",
        "amount": 10000,
        "cash_account_id": 2
      }
    ]
  }
}

SKENERIO PEMBELIAN CICILAN
```
INSERT INTO transactions 
(transaction_type, reference_code, date, created_by, status, payment_status, supplier_id)
VALUES 
('PURCHASE', 'PO-2025-001', '2025-06-28 11:00:00', 1, 'CONFIRMED', 'PARTIAL', 5);
-- anggap id = 3

INSERT INTO transaction_details 
(transaction_id, product_id, warehouse_id, quantity, unit_price, discount, notes)
VALUES 
(3, 40, 1, 10, 10000, 0, 'Pembelian bahan baku');

INSERT INTO transaction_payments 
(transaction_id, total_paid, change_returned)
VALUES (3, 30000, 0);


INSERT INTO transaction_payment_methods
(transaction_payment_id, method, amount, cash_account_id)
VALUES 
(3, 'CASH', 10000, 1),
(3, 'TRANSFER', 20000, 3);


INSERT INTO transaction_payment_history 
(transaction_id, date, amount, method, cash_account_id, notes)
VALUES 
(3, '2025-06-30', 30000, 'TRANSFER', 3, 'Cicilan kedua'),
(3, '2025-07-05', 40000, 'QRIS', 2, 'Cicilan terakhir');

SELECT 
  t.reference_code,
  s.nama_supplier,
  t.date,
  SUM(td.quantity * td.unit_price - td.discount) AS total_pembelian,
  COALESCE(tp.total_paid, 0) + COALESCE(h.total_cicilan, 0) AS total_dibayar,
  (SUM(td.quantity * td.unit_price - td.discount) - 
   (COALESCE(tp.total_paid, 0) + COALESCE(h.total_cicilan, 0))) AS sisa_hutang
FROM transactions t
JOIN table_suplier s ON s.id = t.supplier_id
JOIN transaction_details td ON td.transaction_id = t.id
LEFT JOIN transaction_payments tp ON tp.transaction_id = t.id
LEFT JOIN (
  SELECT transaction_id, SUM(amount) AS total_cicilan
  FROM transaction_payment_history
  GROUP BY transaction_id
) h ON h.transaction_id = t.id
WHERE t.transaction_type = 'PURCHASE'
  AND t.status = 'CONFIRMED'
GROUP BY t.id;


```

json 
{
  "transaction_type": "PURCHASE",
  "reference_code": "PO-2025-001",
  "date": "2025-06-28 11:00:00",
  "created_by": 1,
  "supplier_id": 5,
  "status": "CONFIRMED",
  "payment_status": "PARTIAL",
  "details": [
    {
      "product_id": 40,
      "warehouse_id": 1,
      "quantity": 10,
      "unit_price": 10000,
      "discount": 0,
      "notes": "Pembelian bahan baku"
    }
  ],
  "payment": {
    "total_paid": 30000,
    "change_returned": 0,
    "methods": [
      {
        "method": "CASH",
        "amount": 10000,
        "cash_account_id": 1
      },
      {
        "method": "TRANSFER",
        "amount": 20000,
        "cash_account_id": 3
      }
    ]
  }
}

cicilan transaction payment

[
  {
    "transaction_id": 3,
    "date": "2025-06-30",
    "amount": 30000,
    "method": "TRANSFER",
    "cash_account_id": 3,
    "notes": "Cicilan kedua"
  },
  {
    "transaction_id": 3,
    "date": "2025-07-05",
    "amount": 40000,
    "method": "QRIS",
    "cash_account_id": 2,
    "notes": "Cicilan terakhir"
  }
]

SUMBER : https://chatgpt.com/c/685fe96f-f194-8007-a0b4-3764f9c64277
