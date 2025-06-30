<template>
    <div>
        <MasterForm :title="title" v-if="isInsert || isUpdate" :id="route.params.id" :form-schema="formSchema"
            :api-base="apiBase" />

        <MasterTable v-else :title="title" :columns="columns" :api-base="apiBase" :insert-path="`/${moduleName}/insert`"
            :primary-key="primaryKey" />
    </div>
</template>


<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import MasterForm from '@/components/master/MasterForm.vue'
import MasterTable from '@/components/master/MasterTable.vue'

// 1. Route dan module
const route = useRoute()
const moduleName = 'products' // Nama module sesuai dengan nama file

// 2. Title dinamis
const title = computed(() => {
    if (route.path.includes('/insert')) return `Insert ${capitalize(moduleName)}`
    if (route.path.includes('/update')) return `Update ${capitalize(moduleName)}`
    return `Table ${capitalize(moduleName)}`
})

// 3. Mode
const isInsert = computed(() => route.path.includes('/insert'))
const isUpdate = computed(() => route.path.includes('/update'))

// 4. API base dari env + module name
const apiBase = `${import.meta.env.VITE_API_BASE_URL}/${moduleName}`

// 5. Primary key
const primaryKey = 'idbarang' // Ganti dengan primary key sesuai dengan tabel di database

// 6. Schema form
// 'namabarang', 
//         'golongan',
//         'kategoribarang',
//         'nobatch',
//         'satuan',
//         'hargapokok',
//         'hargajualecer',
//         'tglproduksi',
//         'tglexp',
//         'pajak',
//         'potongan',
const formSchema = [
    { label: 'Nama Produk', model: 'namabarang', type: 'text', required: true },
    { label: 'Golongan', model: 'golongan', type: 'text', required: true },
    { label: 'Kategori Barang', model: 'kategoribarang', type: 'text', required: true },
    { label: 'No Batch', model: 'nobatch', type: 'text', required: true },
    { label: 'Satuan', model: 'satuan', type: 'text', required: true },
    { label: 'Harga Pokok', model: 'hargapokok', type: 'number', required: true },
    { label: 'Harga Jual Eceran', model: 'hargajualecer', type: 'number', required: true },
    { label: 'Tanggal Produksi', model: 'tglproduksi', type: 'date' },
    { label: 'Tanggal Expired', model: 'tglexp', type: 'date' },
    { label: 'Pajak', model: 'pajak', type: 'number' },
    { label: 'Potongan', model: 'potongan', type: 'number' },
]

// 7. Table columns
const columns = [
    { label: 'Nama Produk', key: 'namabarang' },
    { label: 'Golongan', key: 'golongan' },
    { label: 'Kategori Barang', key: 'kategoribarang' },
    { label: 'No Batch', key: 'nobatch' },
    { label: 'Satuan', key: 'satuan' },
    { label: 'Harga Pokok', key: 'hargapokok' },
    { label: 'Harga Jual Eceran', key: 'hargajualecer' },
    { label: 'Tanggal Produksi', key: 'tglproduksi' },
    { label: 'Tanggal Expired', key: 'tglexp' },
    { label: 'Pajak', key: 'pajak' },
    { label: 'Potongan', key: 'potongan' },
]

// 8. Helper capitalize
function capitalize(text) {
    return text.charAt(0).toUpperCase() + text.slice(1)
}
</script>
