<template>
  <section class="table-components">
    <div class="container-fluid">
      <TitlePage :title="title" />
      <div class="card-style mt-3">
        <div class="d-flex flex-wrap justify-content-between align-items-center py-3 gap-3">

          <!-- Search -->
          <div class="flex-grow-1">
            <input type="text" placeholder="🔍 Cari data..." class="form-control form-control-sm"
              v-model="searchQuery" />
          </div>

          <!-- Sort -->
          <div class="d-flex align-items-center gap-2">
            <label class="mb-0 text-sm">Urut:</label>
            <select v-model="sortColumn" class="form-select form-select-sm">
              <option disabled value="">Kolom</option>
              <option v-for="col in columns" :key="col.key" :value="col.key">
                {{ col.label }}
              </option>
              <option value="timestamp">Tanggal</option>
            </select>

            <select v-model="sortDirection" class="form-select form-select-sm">
              <option value="asc">Naik ↑</option>
              <option value="desc">Turun ↓</option>
            </select>
          </div>

          <!-- Date Range -->
          <div class="d-flex align-items-center gap-2">
            <div class="d-flex flex-column">
              <label class="text-sm mb-1">Mulai</label>
              <input type="date" v-model="dateStart" class="form-control form-control-sm" />
            </div>
            <div class="d-flex flex-column">
              <label class="text-sm mb-1">Sampai</label>
              <input type="date" v-model="dateEnd" class="form-control form-control-sm" />
            </div>
          </div>

          <!-- Export Buttons -->
          <div class="d-flex align-items-center gap-2">
            <p class="mb-0 text-sm">Show {{ pagination.limit }} entries</p>
            <button class="btn btn-sm btn-outline-success" @click="exportExcel">
              <i class="lni lni-exit"></i> Excel
            </button>
            <button class="btn btn-sm btn-outline-danger" @click="exportPDF">
              <i class="lni lni-printer"></i> PDF
            </button>
          </div>
        </div>




        <div class="table-wrapper table-responsive">
          <table class="table">
            <thead>
              <tr>
                <th v-for="col in columns" :key="col.key">
                  {{ col.label }}
                </th>
                <th>Action</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in items" :key="index">
                <td v-for="col in columns" :key="col.key">
                  <span v-if="['total_paid', 'change_returned'].includes(col.key)">
                    {{ formatCurrency(item[col.key]) }}
                  </span>
                  <span v-else>
                    {{ item[col.key] }}
                  </span>
                </td>

                <td>
                  <div class="d-flex gap-2">
                    <button @click="handleDetail(item[props.primaryKey])" class="btn btn-sm btn-outline-primary">
                      <i class="lni lni-eye"></i>
                    </button>
                  </div>
                </td>
              </tr>
              <tr v-if="items.length === 0">
                <td :colspan="columns.length + 1" class="text-center">No data found</td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="pt-10 d-flex flex-wrap gap-3 justify-content-between">
          <div class="left">
            <p class="text-sm text-gray">Showing {{ pagination.page * pagination.limit }} / {{ pagination.total_items }}
              data</p>
          </div>
          <div class="right table-pagination">
            <ul class="d-flex justify-content-end align-items-center gap-2">
              <li>
                <button class="px-3 py-1 rounded border text-sm" :disabled="pagination.page <= 1"
                  @click="goToPage(pagination.page - 1)">
                  <i class="lni lni-angle-double-left"></i>
                </button>
              </li>

              <li v-for="page in pagination.total_pages" :key="page">
                <button class="px-3 py-1 rounded border text-sm" :class="{
                  'bg-primary text-white border-primary': page === pagination.page,
                  'border-gray-300 hover:bg-gray-100': page !== pagination.page
                }" @click="goToPage(page)">
                  {{ page }}
                </button>
              </li>

              <li>
                <button class="px-3 py-1 rounded border text-sm" :disabled="pagination.page >= pagination.total_pages"
                  @click="goToPage(pagination.page + 1)">
                  <i class="lni lni-angle-double-right"></i>
                </button>
              </li>
            </ul>
          </div>
        </div>
      </div>

    </div>
  </section>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import TitlePage from '../../layouts/TitlePage.vue'
import debounce from 'lodash.debounce'
import moment from 'moment'

// Props
const props = defineProps({
  title: String,
  columns: Array,
  apiBase: String,
  primaryKey: {
    type: String,
    default: 'id'
  }
})

const emit = defineEmits(['detail'])

// Tools
const route = useRoute()
const router = useRouter()

// State
const items = ref([])
const searchQuery = ref('')
const pagination = ref({
  page: 1,
  limit: 8,
  total_items: 0,
  total_pages: 0,
  first: null,
  last: null,
  next: null,
  previous: null
})

const sortColumn = ref('')
const sortDirection = ref('asc')
const dateStart = ref(moment().subtract(7, 'days').format('YYYY-MM-DD'))
const dateEnd = ref(moment().format('YYYY-MM-DD'))


const exportExcel = () => {
  const params = new URLSearchParams({
    q: searchQuery.value || '',
    sort: `${sortColumn.value}:${sortDirection.value}`,
    date_start: dateStart.value || '',
    date_end: dateEnd.value || ''
  })
  window.open(`${import.meta.env.VITE_API_BASE_URL}/transaksi/keranjang/export-excel?${params.toString()}`, '_blank')
}

const exportPDF = () => {
  const params = new URLSearchParams({
    q: searchQuery.value || '',
    sort: `${sortColumn.value}:${sortDirection.value}`,
    date_start: dateStart.value || '',
    date_end: dateEnd.value || ''
  })
  window.open(`${import.meta.env.VITE_API_BASE_URL}/transaksi/keranjang/export-pdf?${params.toString()}`, '_blank')
}

// Fetch data
const fetchData = async () => {
  // Validasi rentang tanggal maksimal 1 tahun
  const start = moment(dateStart.value)
  const end = moment(dateEnd.value)
  const diff = end.diff(start, 'days')
  if (diff < 0 || diff > 365) {
    console.warn('Rentang tanggal tidak valid (maksimal 1 tahun)')
    return
  }

  try {
    const res = await axios.get(props.apiBase, {
      params: {
        page: pagination.value.page,
        limit: pagination.value.limit,
        q: searchQuery.value || undefined,
        sort_by: sortColumn.value || undefined,
        order: sortDirection.value || undefined,
        date_start: dateStart.value || undefined,
        date_end: dateEnd.value || undefined
      }
    })
    if (res.data.code === 200) {
      items.value = res.data.data.items
      pagination.value = res.data.data.pagination
    }
  } catch (err) {
    console.error('Fetch failed', err)
  }
}

onMounted(fetchData)

watch(searchQuery, debounce(() => {
  pagination.value.page = 1
  fetchData()
}, 400))

watch([sortColumn, sortDirection, dateStart, dateEnd], () => {
  pagination.value.page = 1
  fetchData()
})

const goToPage = (page) => {
  pagination.value.page = page
  fetchData()
}

const handleDetail = (id) => {
  // console.log(id)
  // router.push(`/laporan/penjualan/${id}`)
  emit('detail', id)
}

const formatCurrency = (val) =>
  new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(val || 0)

</script>
