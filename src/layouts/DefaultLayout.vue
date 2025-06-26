<template>
  <div :class="['main-wrapper', { active: isSidebarActive }]">
    <!-- SIDEBAR -->
    <aside class="sidebar">
      <TopHeader/>
      <AsideSidebar />
    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">
      <!-- Dynamic content -->
        <section class="section">
        <div class="container-fluid">
          <router-view />
        </div>
        </section>
      
    </main>
  </div>
</template>

<script setup>
import { ref, provide } from 'vue'
import AsideSidebar from './AsideSidebar.vue'
import TopHeader from './TopHeader.vue'

const isSidebarActive = ref(false)
provide('isSidebarActive', isSidebarActive)
provide('toggleSidebar', () => {
  isSidebarActive.value = !isSidebarActive.value
})
provide('closeSidebar', () => {
  isSidebarActive.value = false
})
</script>
