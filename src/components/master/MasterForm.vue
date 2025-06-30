<template>
  <div class="my-4">
    <router-link :to="parentPath" class="btn btn-secondary">
      ← Back to {{ title }}
    </router-link>
  </div>

  <div class="card-style">
    <h2 class="mb-4">{{ title }}</h2>

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
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

const props = defineProps({
  id: [String, Number],
  title: {
    type: String,
    required: true
  },
  formSchema: {
    type: Array,
    required: true
  },
  apiBase: {
    type: String, // contoh: '/api/users'
    required: true
  }
})

const route = useRoute()
const router = useRouter()

const isInsertMode = computed(() => route.path.includes('/insert'))

const parentPath = computed(() => {
  return route.path.replace(/\/(insert|update)(\/[^/]*)?$/, '')
})

const apiUrls = computed(() => ({
  getOne: `${props.apiBase}/${props.id}`,
  insert: `${props.apiBase}`,
  update: `${props.apiBase}/${props.id}`,
}))

const form = ref({})
props.formSchema.forEach(field => {
  form.value[field.model] = ''
})

onMounted(async () => {
  if (!isInsertMode.value && props.id) {
    try {
      const res = await axios.get(apiUrls.value.getOne)
      const data = res.data.data
      props.formSchema.forEach(field => {
        form.value[field.model] = data[field.model] || ''
      })
    } catch (err) {
      console.error('Failed to fetch data:', err)
    }
  }
})

const handleSubmit = async () => {
  try {
    if (isInsertMode.value) {
      form.value._method = 'post'
      await axios.post(apiUrls.value.insert, form.value)
    } else {
      form.value._method = 'put'
      await axios.post(apiUrls.value.update, form.value)
    }
    alert('Success!')
    router.push(parentPath.value)
  } catch (err) {
    console.error('Save failed:', err)
  }
}
</script>
