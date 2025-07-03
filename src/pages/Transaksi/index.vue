<template>
  <section class="section">
    <TitlePage :title="title" />

    <div class="row">
      <!-- KIRI: Search Produk -->
      <div class="col-lg-4 col-xl-12 col-xxl-4">
        <SearchProducts title="Pencarian Produk" :keyword="searchTerm" @update:keyword="val => searchTerm = val"
          @search="fetchProducts" :products="products" @add="handleAddProduct" />
      </div>

      <!-- KANAN: Keranjang -->
      <div class="col-md-12 col-lg-8 col-xl-12 col-xxl-8">
        <KeranjangTable v-model:items="cart" @detailcart="handdleDetailCart" @delete="handleDeleteAll" @create="handdleAddCart" />
        <Keranjang v-model:items="detailcart" @update="handleUpdateItem" @delete="handleDeleteItem"
          @refresh="fetchKeranjang" @checkout="handleCheckout" />

      </div>

    </div>
  </section>
</template>

<script setup>
import TitlePage from '@/layouts/TitlePage.vue'
import SearchProducts from '@/components/SearchProducts.vue'
import Keranjang from '@/components/Keranjang.vue'
import { useRoute } from 'vue-router'
import Swal from 'sweetalert2'
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import moment from 'moment'
import KeranjangTable from '../../components/KeranjangTable.vue'

const route = useRoute()
const tipe = route.meta.title

const title = ref(tipe)
const mode = ref(route.meta.transactionType || 'SALE')

const products = ref([])
const keranjang = ref([])
const searchTerm = ref('')
const cart = ref([])
const detailcart = ref([])
const selectedCart = ref(null)

const formatCurrency = (val) =>
  new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(val)

// Fetch produk dari API
const fetchProducts = async () => {
  try {
    const res = await axios.get(`${import.meta.env.VITE_API_BASE_URL}/products?q=${searchTerm.value}&limit=10`)
    products.value = res.data.data.items || []
  } catch (error) {
    console.error('Gagal fetch produk:', error)
  }
}

// Fetch keranjang 
const fetchCart = async () => {
  try {
    const res = await axios.get(`${import.meta.env.VITE_API_BASE_URL}/transaksicart/cart?transaction_type=${mode.value}&status=DRAFT`)
    cart.value = res.data.data.items || []
  } catch (error) {
    console.error('Gagal fetch cart:', error)
  }
}

// Create Cart
const handdleAddCart = async (id) => {
  try {
    const res = await axios.post(`${import.meta.env.VITE_API_BASE_URL}/transaksicart/cart`,{
        "user_id": 1,
        "transaction_type": mode.value,
        "status": "DRAFT"
    })
    fetchCart()
    // console.log(res.data.data.items)
  } catch (error) {
    console.error('Gagal fetch detail keranjang:', error)
  }
}

// Detail Cart
const handdleDetailCart = async (id) => {
  try {
    const res = await axios.get(`${import.meta.env.VITE_API_BASE_URL}/transaksicart/cart/${id}/item`)
    detailcart.value = res.data.data.items || []
    selectedCart.value = id
    console.log(id)
  } catch (error) {
    console.error('Gagal fetch detail keranjang:', error)
  }
}

// Edit Detail Cart

// Fetch keranjang item
const fetchKeranjang = async () => {
  try {
    const res = await axios.get(`${import.meta.env.VITE_API_BASE_URL}/transaksi/keranjang?mode=${mode.value}`)
    keranjang.value = res.data.data.items || []
  } catch (error) {
    console.error('Gagal fetch keranjang:', error)
  }
}



// Saat mount
onMounted(() => {
  console.log('Transaksi mode:', mode.value)
  fetchProducts()
  fetchKeranjang()
  fetchCart()
})

// Tambah produk ke keranjang
const handleAddProduct = async (product) => {
  try {
    if(selectedCart.value==null){
      Swal.fire('Gagal', 'Transaksi belum dipilih', 'error')
      return
    }
    await axios.post(`${import.meta.env.VITE_API_BASE_URL}/transaksicart/cart/${selectedCart.value}/items`, {
      "product_id": product.idbarang,
      "warehouse_id": 1,
      "quantity": 1,
      "unit_price": product.hargajualecer,
      "discount": 0,
      "notes": ""
    })
    fetchKeranjang()
    handdleDetailCart(selectedCart.value)
  } catch (e) {
    console.error('Gagal tambah produk:', e)
  }
}

// Update item di keranjang
const handleUpdateItem = async (item) => {
  try {
    console.log(item)
    await axios.post(`${import.meta.env.VITE_API_BASE_URL}/transaksicart/cart/items/${item.id}`, {
      "product_id": item.product_id,
      "warehouse_id": 1,
      "quantity": item.quantity,
      "unit_price": item.unit_price,
      "discount": item.discount,
      "notes": "Barang promo",
      "_method": "put"
    })
  } catch (e) {
    console.error('Gagal update:', e)
  }
}

// Hapus satu item
const handleDeleteItem = async (item) => {
  try {
    await axios.post(`${import.meta.env.VITE_API_BASE_URL}/transaksicart/cart/items/${item.id}/delete`,{
      "_method":"delete"
    })
    fetchKeranjang()
  } catch (e) {
    console.error('Gagal hapus item:', e)
  }
}

// Kosongkan semua
const handleDeleteAll = async (id) => {
  try {
    await axios.post(`${import.meta.env.VITE_API_BASE_URL}/transaksicart/cart/${id}/delete`, {
      "_method": "delete"
    })
    fetchKeranjang()
  } catch (e) {
    console.error('Gagal kosongkan keranjang:', e)
  }
}

const handleCheckout = async ({ tunai, nontunai, total, kembalian }) => {
  const confirm = await Swal.fire({
    title: 'Konfirmasi Checkout',
    html: `
      <p>Total Bayar: <b>${formatCurrency(total)}</b></p>
      <p>Tunai: <b>${formatCurrency(tunai)}</b></p>
      <p>Non-Tunai: <b>${formatCurrency(nontunai)}</b></p>
      <p>Kembalian: <b>${formatCurrency(kembalian)}</b></p>
    `,
    icon: 'info',
    showCancelButton: true,
    confirmButtonText: 'Ya, Checkout',
    cancelButtonText: 'Batal'
  })

  if (!confirm.isConfirmed) return

  try {
    // dapatkan item di keranjang
    const items = keranjang.value.map(item => ({
      product_id: item.idbarang,
      warehouse_id: item.idgudang || 1,
      quantity: item.jumlah,
      unit_price: item.hargajualecer,
      discount: item.potongan || 0,
      notes: item.catatan || ''
    }))
    // console.log('Items to checkout:', items)

    // dapatkan payment methods
    const paymentMethods = []
    if (tunai > 0) {
      paymentMethods.push({
        method: 'CASH',
        amount: tunai,
        cash_account_id: 1 // ganti dengan ID akun kas yang sesuai
      })
      paymentMethods.push({
        method: 'NON_CASH',
        amount: nontunai,
        cash_account_id: 1 // ganti dengan ID akun kas yang sesuai
      })
    }

    // dapatkan payment total
    const paymentTotal = tunai + nontunai
    if (paymentTotal < total) {
      Swal.fire('Gagal', 'Total pembayaran tidak cukup.', 'error')
      return
    }
    const payment = {
      total_paid: paymentTotal,
      change_returned: kembalian
    }

    let data = {
      "transactionCartId": selectedCart.value,
      "reference_code": null,
      "transaction_type": mode.value,
      "date": moment().format('YYYY-MM-DD HH:mm:ss'),
      "created_by": 1,
      "status": "CONFIRMED",
      "payment_status": "PAID",
      "items": items,
      "payment": payment,
      "payment_methods": paymentMethods
    }

    await axios.post(`${import.meta.env.VITE_API_BASE_URL}/transaksi/${mode.value}`, data)
    Swal.fire('Berhasil', 'Transaksi berhasil diselesaikan.', 'success')
  .then(() => {
    location.reload(true); // Hard reload (force reload from server)
  });

    
  } catch (e) {
    Swal.fire('Gagal', 'Terjadi kesalahan saat checkout.', 'error')
  }
}

</script>
