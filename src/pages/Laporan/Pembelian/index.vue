<template>
  <div>
    <!-- ✅ Tampilkan daftar jika bukan detail -->
    <LaporanTable
      v-if="!isDetailPage"
      :title="title"
      :columns="columns"
      :api-base="apiBase"
      :insert-path="`/laporan/penjualan/insert`"
      :primary-key="primaryKey"
    />

    <!-- ✅ Tampilkan detail jika segment ID valid -->
    <LaporanDetail
      v-else
      :id="lastSegment"
      :title="title"
      :api-base="apiBase"
      :primary-key="primaryKey"
      :columns="columns"
    />
  </div>
</template>

<script setup>
import { useRoute } from 'vue-router'
import { computed } from 'vue'
import LaporanTable from '@/components/laporan/LaporanTable.vue'
import LaporanDetail from '@/components/laporan/LaporanDetail.vue'

const route = useRoute()
const title = 'Laporan Pembelian'

const apiBase = `${import.meta.env.VITE_API_BASE_URL}/laporan/PURCHASE?status=CONFIRMED&payment_status=PAID`
const primaryKey = 'reference_code'

const columns = [
  { label: 'Nota Penjualan', key: 'reference_code' },
  { label: 'Tanggal', key: 'date' },
  { label: 'Status Pembayaran', key: 'payment_status' },
  { label: 'Status', key: 'status' },
  { label: 'Total Pembayaran', key: 'total_paid' },
  { label: 'Kembalian', key : 'change_returned'}
]

// ✅ Buat reactive last segment dari path
const lastSegment = computed(() => {
  const segments = route.path.split('/').filter(Boolean)
  return segments.length > 0 ? segments[segments.length - 1] : ''
})

// ✅ Deteksi apakah halaman detail berdasarkan pola ID nota
const isDetailPage = computed(() => lastSegment.value.length >= 10) // contoh SE-xxx... minimal panjang ID

</script>
