<template>
  <div class="card-style activity-card mb-30">
    <div class="title d-flex flex-wrap align-items-center justify-content-between mb-10">
      <div class="left mb-2">
        <h6 class="text-medium mb-2">{{ title }}</h6>
      </div>
      <div class="w-100">
        <div class="input-style-3 w-100">
          <input
            type="text"
            placeholder="Ketik beberapa kata kunci untuk mencari produk."
            class="w-100"
            v-model="localKeyword"
          />
          <span class="icon"><i class="lni lni-search"></i></span>
        </div>
      </div>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-2">
      <h6 class="mb-0">Daftar Produk</h6>
      <button class="btn btn-sm btn-outline-secondary" @click="$emit('search')">
        <i class="lni lni-reload"></i> Refresh
      </button>
    </div>

    <div class="table-responsive">
      <table class="table activity-table table-sm text-sm">
        <tbody>
          <tr v-for="product in products" :key="product.idbarang" class="py-4">
            <td style="border-bottom: 1px solid #dee2e6;">
              <span class="text-xs text-gray ms-2 fw-500 text-truncate">{{ product.namabarang }}</span><br>
              <p class="text-xs fw-500 ms-2 text-gray">
                (QTY: {{ product.current_quantity || 'out of stock' }})
                {{ formatCurrency(product.hargajualecer) }}
              </p>
            </td>
            <td style="border-bottom: 1px solid #dee2e6;" class="text-end">
              <button
                v-if="product.current_quantity > 0"
                class="btn btn-xs btn-outline-primary"
                @click="$emit('add', product)"
              >
                <i class="lni lni-plus"></i>
              </button>
            </td>
          </tr>
          <tr v-if="products.length === 0">
            <td colspan="2" class="text-center text-gray text-sm">Tidak ada produk ditemukan.</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  title: String,
  keyword: String,
  products: Array
})

const emit = defineEmits(['update:keyword', 'search', 'add'])

const localKeyword = ref(props.keyword)

watch(() => props.keyword, (val) => {
  if (val !== localKeyword.value) localKeyword.value = val
})

watch(localKeyword, (val) => {
  emit('update:keyword', val)
  emit('search') // optional, bisa hapus kalau trigger manual
})

const formatCurrency = (val) =>
  new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(val)
</script>
