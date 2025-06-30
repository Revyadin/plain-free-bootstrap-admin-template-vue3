<template>
  <div>
    <MasterForm
      :title="title"
      v-if="isInsert || isUpdate"
      :id="route.params.id"
      :form-schema="formSchema"
      :api-base="apiBase"
    />

    <MasterTable
      v-else
      :title="title"
      :columns="columns"
      :api-base="apiBase"
      :insert-path="`/${moduleName}/insert`"
      :primary-key="primaryKey"
    />
  </div>
</template>


<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import MasterForm from '@/components/master/MasterForm.vue'
import MasterTable from '@/components/master/MasterTable.vue'

// 1. Route dan module
const route = useRoute()
const moduleName = 'supplier'

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
const primaryKey = 'idsuplayer'

// 6. Schema form
const formSchema = [
  { label: 'Name', model: 'namasuplayer', type: 'text', required: true },
  { label: 'Whatsapp', model: 'wasuplayer', type: 'text', required: true },
  { label: 'Keterangan', model: 'keterangan', type: 'text', required: false },
]

// 7. Table columns
const columns = [
  { label: 'Name', key: 'namasuplayer' },
  { label: 'Whatsapp', key: 'wasuplayer' },
  { label: 'Keterangan', key: 'keterangan' },
]

// 8. Helper capitalize
function capitalize(text) {
  return text.charAt(0).toUpperCase() + text.slice(1)
}
</script>

