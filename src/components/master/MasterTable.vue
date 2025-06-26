<template>
  <section class="table-components">
    <div class="container-fluid">
      <div class="title-wrapper pt-30 d-flex justify-content-between align-items-center">
        <h2>{{ title }}</h2>
        <router-link :to="insertPath" class="btn btn-primary">Insert</router-link>
      </div>

      <div class="card-style mt-3">
        <div class="d-flex justify-content-between align-items-center py-2">
          <div>
            <p>Show {{ items.length }} entries</p>
          </div>
          <div class="table-search">
            <input
              type="text"
              placeholder="Search..."
              class="form-control"
              v-model="searchQuery"
            />
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
              <tr v-for="(item, index) in filteredItems" :key="index">
                <td v-for="col in columns" :key="col.key">
                  {{ item[col.key] }}
                </td>
                <td>
                  <div class="d-flex gap-2">
                    <button @click="handleEdit(item.id)" class="btn btn-sm btn-outline-primary">
                      <i class="lni lni-pencil"></i>
                    </button>
                    <button @click="confirmDelete(item)" class="btn btn-sm btn-outline-danger">
                      <i class="lni lni-trash-can"></i>
                    </button>
                  </div>
                </td>
              </tr>
              <tr v-if="filteredItems.length === 0">
                <td :colspan="columns.length + 1" class="text-center">No data found</td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="pt-10 d-flex flex-wrap gap-3 justify-content-between">
                  <div class="left">
                    <p class="text-sm text-gray">Showing 12/30 products</p>
                  </div>
                  <div class="right table-pagination">
                    <ul class="d-flex justify-content-end align-items-center gap-2">
                      <li>
                        <a href="#0">
                          <i class="lni lni-angle-double-left"></i>
                        </a>
                      </li>
                      <li>
                        <a href="#0"> 1 </a>
                      </li>
                      <li>
                        <a href="#0" class="active"> 2 </a>
                      </li>
                      <li>
                        <a href="#0"> 3 </a>
                      </li>
                      <li>
                        <a href="#0"> 4 </a>
                      </li>
                      <li>
                        <a href="#0">
                          <i class="lni lni-angle-double-right"></i>
                        </a>
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
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

// Props
const props = defineProps({
  title: String,
  columns: Array, // ex: [{ label: 'Name', key: 'name' }]
  apiBase: String, // ex: '/api/users'
  insertPath: String // ex: '/user/insert'
})

// Tools
const route = useRoute()
const router = useRouter()

// State
const items = ref([])
const searchQuery = ref('')
const showModal = ref(false)
const selectedItem = ref(null)

// Fetch data
const fetchData = async () => {
  try {
    const res = await axios.get(props.apiBase)
    items.value = res.data
  } catch (err) {
    console.error('Fetch failed', err)
  }
}

onMounted(fetchData)

const filteredItems = computed(() => {
  if (!searchQuery.value) return items.value
  return items.value.filter(item =>
    Object.values(item).some(val =>
      String(val).toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  )
})

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
    await axios.delete(`${props.apiBase}/${selectedItem.value.id}`)
    items.value = items.value.filter(i => i.id !== selectedItem.value.id)
    showModal.value = false
  } catch (err) {
    console.error('Delete failed', err)
  }
}
</script>
