<template>
  <component :is="layoutComponent">
    <router-view />
  </component>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import DefaultLayout from '@/layouts/DefaultLayout.vue'
import AuthLayout from '@/layouts/AuthLayout.vue'

const route = useRoute()

const layoutMap = {
  default: DefaultLayout,
  auth: AuthLayout
}

const layoutComponent = computed(() => {
  const matched = route.matched.slice().reverse().find(r => r.meta?.layout)
  const layoutKey = matched?.meta?.layout || 'default'
  return layoutMap[layoutKey]
})
</script>
