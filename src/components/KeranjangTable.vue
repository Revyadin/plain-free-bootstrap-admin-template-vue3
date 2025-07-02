<template>
  <div class="card-style mb-30">
    <h6 class="mb-10">Draft Transaksi</h6>
    <p class="text-sm mb-20">
      Transaksi ditampilkan sebagai badge. Klik tombol aksi untuk melihat atau mengelola transaksi.
    </p>

    <div v-if="localItems.length === 0" class="text-center text-sm text-muted">
      Tidak ada transaksi ditemukan.
    </div>

    <div v-else class="badges-group d-flex flex-column gap-2 clickable-badge-card">
      <div
        v-for="(item, index) in localItems"
        :key="item.id"
        class="d-flex justify-content-between align-items-center p-2 border rounded bg-light"
        @click="$emit('detailcart', item.id)"
      >
        <div>
          <h6 class="mb-1">#{{ index + 1 }} - {{ formatDate(item.created_at) }}</h6>
          <span :class="['main-badge', 'badge-sm', getStatusBadge(item.status)]">
            {{ item.status }}
          </span>
        </div>
        <div class="d-flex gap-1">
          <button class="btn btn-sm btn-danger" @click="$emit('delete', item.id)">x</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import moment from 'moment'

const props = defineProps({
  items: Array
})

const emit = defineEmits([
  'detailcart',
  'delete'
])

const localItems = ref([...props.items])

watch(() => props.items, (val) => {
  localItems.value = [...val]
})

const formatDate = (val) => moment(val).format('DD/MM/YYYY HH:mm')

// Fungsi untuk badge warna berdasarkan status
const getStatusBadge = (status) => {
  switch (status?.toLowerCase()) {
    case 'draft':
      return 'warning-badge-light'
    case 'paid':
    case 'success':
    case 'confirmed':
      return 'success-badge-light'
    case 'cancelled':
    case 'failed':
      return 'danger-badge-light'
    default:
      return 'secondary-badge-light'
  }
}
</script>
<style scoped>
.clickable-badge-card {
  @apply d-flex justify-between align-items-center p-3 mb-2 border rounded bg-light;
  cursor: pointer;
  transition: all 0.2s ease-in-out;
}

.clickable-badge-card:hover {
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  background-color: #f8f9fa;
}

.clickable-badge-card:active {
  transform: scale(0.98);
}
</style>

