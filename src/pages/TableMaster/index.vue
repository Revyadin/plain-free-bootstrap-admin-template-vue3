<template>
  <div>
    <MasterForm
      title="Table Master"
      v-if="isInsert || isUpdate"
      :id="route.params.id"
      :form-schema="formSchema"
      api-base="/api/users"
    />
    
    <MasterTable
      v-else
      title="Table Master"
      :columns="columns"
      api-base="http://localhost:3001/users"
      insert-path="/tablemaster/insert"
    />
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import MasterForm from '@/components/master/MasterForm.vue'
import MasterTable from '@/components/master/MasterTable.vue'

const route = useRoute()

// Cek mode
const isInsert = computed(() => route.path.includes('/insert'))
const isUpdate = computed(() => route.path.includes('/update'))

// Skema untuk form
const formSchema = [
  { label: 'Name', model: 'name', type: 'text', required: true },
  { label: 'Email', model: 'email', type: 'email', required: true },
  { label: 'Phone', model: 'phone', type: 'text', required: false },
  { label: 'Company', model: 'company', type: 'text', required: false },
]

// Skema untuk table
const columns = [
  { label: 'Name', key: 'name' },
  { label: 'Email', key: 'email' },
  { label: 'Phone', key: 'phone' },
  { label: 'Company', key: 'company' },
]
</script>
