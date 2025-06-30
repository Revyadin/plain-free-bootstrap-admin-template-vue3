<template>
  <section class="section">
    <TitlePage :title="title" />

    <div class="row">
      <!-- KIRI: Search Produk -->
      <div class="col-lg-4 col-xl-12 col-xxl-4">
        <SearchProducts
          title="Pencarian Produk"
          :keyword="searchTerm"
          @update:keyword="val => searchTerm = val"
          @search="fetchProducts"
          :products="products"
          @add="handleAddProduct"
        />
      </div>

      <!-- KANAN: Keranjang -->
      <div class="col-md-12 col-lg-8 col-xl-12 col-xxl-8">
        <Keranjang
  v-model:items="keranjang"
  @update="handleUpdateItem"
  @delete="handleDeleteItem"
  @refresh="fetchKeranjang"
/>
      </div>
    </div>
  </section>
</template>

<script setup>
import TitlePage from '@/layouts/TitlePage.vue'
import SearchProducts from '@/components/SearchProducts.vue'
import Keranjang from '@/components/Keranjang.vue'

import { ref, computed, onMounted } from 'vue'
import axios from 'axios'

const title = ref('Etalase Penjualan')
const mode = ref('penjualan') // bisa diganti jadi 'pembelian'

const products = ref([])
const keranjang = ref([])
const searchTerm = ref('')

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
  fetchProducts()
  fetchKeranjang()
})

// Tambah produk ke keranjang
const handleAddProduct = async (product) => {
  try {
    await axios.post(`${import.meta.env.VITE_API_BASE_URL}/transaksi/keranjang`, {
      idbarang: product.idbarang,
      mode: mode.value
    })
    fetchKeranjang()
  } catch (e) {
    console.error('Gagal tambah produk:', e)
  }
}

// Update item di keranjang
const handleUpdateItem = async (item) => {
  try {
    await axios.put(`${import.meta.env.VITE_API_BASE_URL}/transaksi/keranjang/${item.idkeranjang}`, {
      jumlah: item.jumlah,
      potongan: item.potongan
    })
  } catch (e) {
    console.error('Gagal update:', e)
  }
}

// Hapus satu item
const handleDeleteItem = async (item) => {
  try {
    await axios.delete(`${import.meta.env.VITE_API_BASE_URL}/transaksi/keranjang/${item.idkeranjang}`)
    fetchKeranjang()
  } catch (e) {
    console.error('Gagal hapus item:', e)
  }
}

// Kosongkan semua
const handleDeleteAll = async () => {
  try {
    await axios.post(`${import.meta.env.VITE_API_BASE_URL}/transaksi/keranjang/deleteall`, {
      mode: mode.value
    })
    fetchKeranjang()
  } catch (e) {
    console.error('Gagal kosongkan keranjang:', e)
  }
}

// Total hitung
const grandTotal = computed(() =>
  keranjang.value.reduce((total, item) => total + item.hargajualecer * item.jumlah, 0)
)

const formatCurrency = (val) =>
  new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(val)
</script>
