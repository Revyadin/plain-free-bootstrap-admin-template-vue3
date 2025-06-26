<template>
  <div class="mb-4">
    <router-link :to="parentPath" class="btn btn-secondary">
      ← Back to Table
    </router-link>
  </div>

  <div class="card-style">
    <h2 class="mb-4">{{ isInsertMode ? 'Insert' : 'Update' }}</h2>

    <form @submit.prevent="handleSubmit">
      <div
        v-for="(field, index) in formSchema"
        :key="index"
        class="mb-3"
      >
        <label class="form-label">{{ field.label }}</label>
        <input
          v-if="field.type !== 'textarea'"
          v-model="form[field.model]"
          :type="field.type"
          class="form-control"
          :required="field.required"
        />
        <textarea
          v-else
          v-model="form[field.model]"
          class="form-control"
          :required="field.required"
        ></textarea>
      </div>

      <button type="submit" class="btn btn-primary">
        {{ isInsertMode ? 'Save' : 'Update' }}
      </button>
    </form>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

// Route dan Router
const route = useRoute()
const router = useRouter()

// Props dari route (jika update)
const props = defineProps({
  id: {
    type: [String, Number],
    default: null
  }
})

// Mode insert/update
const isInsertMode = computed(() => route.path.includes('/insert'))

// Parent path dinamis
const parentPath = computed(() => {
  return route.path.replace(/\/(insert|update)(\/[^/]*)?$/, '')
})

// Nama entitas (berasal dari URL, misal: tablemaster)
const entityName = computed(() => route.path.split('/')[1] || '')

// Base API
const apiBase = computed(() => `https://jsonplaceholder.typicode.com/${entityName.value}`)

// API endpoints
const apiUrls = computed(() => ({
  getOne: `${apiBase.value}/${props.id}`,
  insert: `${apiBase.value}`,
  update: `${apiBase.value}/${props.id}`,
}))

// Skema form dinamis
const formSchema = ref([
  { label: 'Name', model: 'name', type: 'text', required: true },
  { label: 'Email', model: 'email', type: 'email', required: true },
  { label: 'Phone', model: 'phone', type: 'text', required: false },
  { label: 'Company', model: 'company', type: 'text', required: false },
])

// Data form kosong
const form = ref({})

// Inisialisasi form kosong berdasarkan schema
formSchema.value.forEach(field => {
  form.value[field.model] = ''
})

// Ambil data untuk update
onMounted(async () => {
  if (!isInsertMode.value && props.id) {
    try {
      const res = await axios.get(apiUrls.value.getOne)
      const data = res.data
      formSchema.value.forEach(field => {
        form.value[field.model] = data[field.model] || ''
      })
    } catch (err) {
      console.error('Failed to fetch data:', err)
    }
  }
})

// Simpan data
const handleSubmit = async () => {
  try {
    if (isInsertMode.value) {
      await axios.post(apiUrls.value.insert, form.value)
    } else {
      await axios.put(apiUrls.value.update, form.value)
    }
    alert('Success!')
    router.push(parentPath.value)
  } catch (err) {
    console.error('Save failed:', err)
  }
}
</script>
