<template>
    <section class="section">
        <div class="row">
            <!-- Tombol Cetak & Download -->
            <div class="col-12 mb-3">
                <div class="d-flex flex-wrap align-items-center justify-content-between">
                    <h3 class="mb-2">{{ id }}</h3>
                    <div class="d-flex gap-2">
                        <button class="main-btn primary-btn-outline btn-hover btn-sm" @click="downloadStruk">
                            ⬇️ Download TXT
                        </button>
                        <button class="main-btn primary-btn btn-hover btn-sm" @click="printStruk">
                            🖨️ Print Thermal
                        </button>
                    </div>
                </div>
            </div>

            <!-- Kolom utama invoice -->
            <div class="col-lg-9 col-xl-12 col-xxl-9">
                <div class="card-style activity-card mb-30">
                    <div class="invoice-action">
                        <ul class="d-flex flex-wrap align-items-center justify-content-center">
                            <li class="m-2">
                                <a href="#0" class="main-btn primary-btn-outline btn-hover">
                                    Download Invoice
                                </a>
                            </li>
                            <li class="m-2">
                                <a href="#0" class="main-btn primary-btn btn-hover">
                                    Send Invoice
                                </a>
                            </li>
                        </ul>
                    </div>
                    <div class="table-responsive">
                        <div class="invoice-card card-style mb-30">
                            <div class="invoice-header">
                                <div class="invoice-for">
                                    <h2 class="mb-10">{{ data.header }}</h2>
                                    <p class="text-sm">
                                        {{ data.subheader }}
                                        {{ data.telp ? `Telp: ${data.telp}` : '' }}
                                    </p>
                                </div>
                                <div class="invoice-logo">
                                    <img src="https://demo.plainadmin.com/assets/images/invoice/uideck-logo.svg" alt="">
                                </div>
                                <div class="invoice-date">
                                    <p><span>Date :</span> {{ data.tanggal }}</p>
                                    <p><span>ID:</span> {{ data.noNota }}</p>
                                </div>
                            </div>
                            <div class="invoice-address">
                                <div class="address-item">
                                    <h5 class="text-bold">User</h5>
                                    <h1>{{ data.user }}</h1>
                                </div>
                                <div class="address-item">
                                    <h5 class="text-bold">To</h5>
                                    <h1>-</h1>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="invoice-table table">
                                    <thead>
                                        <tr>
                                            <th class="service">
                                                <h6 class="text-sm text-medium">Nama Produk</h6>
                                            </th>
                                            <th class="desc">
                                                <h6 class="text-sm text-medium">Harga Jual</h6>
                                            </th>
                                            <th class="desc">
                                                <h6 class="text-sm text-medium">Potongan</h6>
                                            </th>
                                            <th class="qty">
                                                <h6 class="text-sm text-medium">Qty</h6>
                                            </th>
                                            <th class="amount">
                                                <h6 class="text-sm text-medium">Subtotal</h6>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="(item, index) in data.items" :key="index">
                                            <td>
                                                <p class="text-sm">{{ item.nama }}</p>
                                            </td>
                                            <td>
                                                <p class="text-sm">{{ item.harga }}</p>
                                            </td>
                                            <td>
                                                <p class="text-sm">{{ item.potongan }}</p>
                                            </td>
                                            <td>
                                                <p class="text-sm">{{ item.qty }}</p>
                                            </td>
                                            <td>
                                                <p class="text-sm">{{ item.subtotal }}</p>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td>
                                                <h6 class="text-sm text-medium">Bayar</h6>
                                            </td>
                                            <td>
                                                <h6 class="text-sm text-bold">{{ data.bayar }}</h6>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td>
                                                <h6 class="text-sm text-medium">Kembali</h6>
                                            </td>
                                            <td>
                                                <h6 class="text-sm text-bold">{{ data.kembali }}</h6>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td>
                                                <h4>Total</h4>
                                            </td>
                                            <td>
                                                <h4>{{ data.total }}</h4>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Struk Sidebar -->
            <div class="col-md-6 col-lg-3 col-xl-6 col-xxl-3">
                <div class="card-style mb-30">
                    <div class="title d-flex flex-wrap align-items-center justify-content-between mb-10">
                        <div class="left">
                            <h6 class="text-medium mb-2">Invoice Details</h6>
                        </div>
                    </div>
                    <div class="px-2">
                        <label>Lebar Struk</label>
                        <select class="form-select mb-2" v-model="width" @change="updateStruk">
                            <option :value="30">30</option>
                            <option :value="32">32</option>
                            <option :value="40">40</option>
                        </select>
                        <label>Ukuran Font</label>
                        <select class="form-select mb-2" v-model="fontSize" @change="updateStruk">
                            <option :value="10">10px</option>
                            <option :value="12">12px</option>
                            <option :value="14">14px</option>
                        </select>
                    </div>
                    <!-- line horizontal -->
                    <hr>
                    <div class="table-responsive">
                        <pre :style="strukStyle" ref="printArea">{{ struk }}</pre>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useStrukNota } from '@/helpers/useStrukNota'
import axios from 'axios'

const props = defineProps({
    id: {
        type: String,
        required: true
    }
})

const width = ref(30)
const fontSize = ref(12)
const struk = ref('')
const strukStyle = ref({})
const printArea = ref(null)

let generateStruk = () => ''
let getStrukStyle = () => ({})

// ✅ Gunakan ref agar bisa diisi dari fetch
const data = ref({
    header: 'TOKO MAKMUR JAYA',
    subheader: 'Jl. Kenangan No. 1',
    telp: '08123456789',
    user: 'Admin',
    noNota: '',
    tanggal: '',
    items: [],
    total: 0,
    bayar: 0,
    kembali: 0,
    footer: 'Terima kasih, kembali lagi ya!'
})

function updateStruk() {
    const composable = useStrukNota({
        width: width.value,
        fontSize: fontSize.value
    })
    generateStruk = composable.generateStruk
    getStrukStyle = composable.getStrukStyle

    struk.value = generateStruk(data.value)
    strukStyle.value = getStrukStyle()
}

function printStruk() {
    const win = window.open('', '', 'width=400,height=600')
    win.document.write(`
    <pre style="font-family: Courier New; font-size: ${fontSize.value}px; white-space: pre-wrap;">
${struk.value}
    </pre>
  `)
    win.document.close()
    win.focus()
    win.print()
    win.close()
}

function downloadStruk() {
    const blob = new Blob([struk.value], { type: 'text/plain' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = 'struk.txt'
    a.click()
    URL.revokeObjectURL(url)
}

const fetchData = async () => {
    try {
        const response = await axios(`${import.meta.env.VITE_API_BASE_URL}/laporan/nota_penjualan/${props.id}`)
        const result = response.data.data.items

        // Ubah hasil dari backend ke struktur `data.value`
        data.value.noNota = result.idnotapenjualan
        data.value.tanggal = result.timestamp
        data.value.user = result.user || 'Admin'
        data.value.items = result.detail_penjualan.map(item => ({
            nama: item.namabarang,
            qty: parseInt(item.jumlah),
            harga: parseFloat(item.hargajual),
            potongan: parseFloat(item.potongan),
            subtotal: parseFloat(item.subtotal)
        }))
        data.value.total = parseFloat(result.totalpembayaran)
        data.value.bayar = parseFloat(result.totalpembayarannontunai) + parseFloat(result.totalpembayaran)
        data.value.kembali = data.value.bayar - data.value.total

        updateStruk()
    } catch (error) {
        console.error('Error fetching data:', error)
    }
}

watch([width, fontSize], updateStruk)
onMounted(() => {
    fetchData()
})
</script>
