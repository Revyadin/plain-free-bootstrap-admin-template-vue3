<template>
  <section class="table-components">
    <div class="container-fluid">
      <TitlePage :title="title" />
      <div class="card-style mt-3">
        <div class="d-flex justify-content-between align-items-center py-2">
          <div>
            <p>Show {{ pagination.limit }} entries</p>
            <router-link :to="insertPath" class="btn btn-primary">Insert</router-link>
          </div>
          <div class="table-search">
            <input type="text" placeholder="Search..." class="form-control" v-model="searchQuery" />
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
                  {{ item[col.key] }}
                </td>
                <td>
                  <div class="d-flex gap-2">
                    <button @click="handleEdit(item[props.primaryKey])" class="btn btn-sm btn-outline-primary">
                      <i class="lni lni-pencil"></i>
                    </button>
                    <button @click="confirmDelete(item)" class="btn btn-sm btn-outline-danger">
                      <i class="lni lni-trash-can"></i>
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

      <!-- Modal Delete -->
      <div class="modal fade show" v-if="showModal" style="display: block;" role="dialog">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content card-style warning-card text-center">
            <div class="modal-body">
              <div class="icon text-danger mb-20">
                <i class="lni lni-warning"></i>
              </div>
              <h2 class="mb-15">Warning!</h2>
              <p class="text-sm text-medium">
                Are you sure you want to delete <strong>{{ selectedItem?.[columns[0].key] }}</strong>?
              </p>
              <div class="d-flex justify-content-center gap-2 mt-3">
                <button @click="showModal = false" class="btn btn-sm btn-outline-secondary">Cancel</button>
                <button @click="handleDelete" class="btn btn-sm btn-danger">Delete</button>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </section>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import TitlePage from '../../layouts/TitlePage.vue'
import debounce from 'lodash.debounce'

// Props
const props = defineProps({
  title: String,
  columns: Array, // ex: [{ label: 'Name', key: 'name' }]
  apiBase: String, // ex: '/api/users'
  insertPath: String, // ex: '/user/insert'
  primaryKey: {
    type: String,
    default: 'id' // fallback
  }
})

// Tools
const route = useRoute()
const router = useRouter()

// State
const items = ref([])
const searchQuery = ref('')
const showModal = ref(false)
const selectedItem = ref(null)
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

// Fetch data
const fetchData = async () => {
  try {
    const res = await axios.get(props.apiBase, {
      params: {
        page: pagination.value.page,
        limit: pagination.value.limit,
        sort_by: null,
        order: 'asc',
        q: searchQuery.value || undefined // ← ini yang penting
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


const goToPage = (page) => {
  pagination.value.page = page
  fetchData()
}


// Edit
const handleEdit = (id) => {
  router.push(`${route.path.replace(/\/$/, '')}/update/${id}`)
}

// Delete
const confirmDelete = (item) => {
  selectedItem.value = item
  showModal.value = true
}

const handleDelete = async () => {
  try {
    await axios.post(`${props.apiBase}/${selectedItem.value[props.primaryKey]}`,{ _method: 'delete' })
    items.value = items.value.filter(i => i[props.primaryKey] !== selectedItem.value[props.primaryKey])
    showModal.value = false
  } catch (err) {
    console.error('Delete failed', err)
  }
}
</script>
