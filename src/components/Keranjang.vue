<template>
  <div class="card-style mb-30">
    <slot name="header" />

    <!-- TABEL PRODUK -->
    <div class="table-responsive">
      <table class="table sell-order-table table-sm text-sm">
        <thead>
          <tr>
            <th><h6 class="text-sm fw-500">Produk</h6></th>
            <th><h6 class="text-sm fw-500">Jumlah</h6></th>
            <th><h6 class="text-sm fw-500">Pot. %</h6></th>
            <th class="text-end"><h6 class="text-sm fw-500">Total</h6></th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="localItems.length === 0">
            <td colspan="5" class="text-center text-sm text-gray">Belum ada produk ditambahkan.</td>
          </tr>
          <tr v-for="item in localItems" :key="item.idbarang" style="border-bottom: 1px solid #dee2e6;">
            <td>{{ item.namabarang }}</td>
            <td>
              <input type="number"
                     class="form-control form-control-sm"
                     v-model.number="item.quantity"
                     min="1"
                     style="width: 70px;"
                     @change="onUpdate(item)" />
            </td>
            <td>
              <input type="number"
                     class="form-control form-control-sm"
                     v-model.number="item.discount"
                     min="0" max="100"
                     style="width: 60px;"
                     @change="onUpdate(item)" />
            </td>
            <td class="text-end">
              <p class="text-sm fw-500 text-gray">{{ formatCurrency(hitungTotalItem(item)) }}</p>
            </td>
            <td>
              <button class="btn btn-xs btn-danger" @click="$emit('delete', item)">✕</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- RINGKASAN TOTAL -->
    <div class="mt-3">
      <div class="d-flex justify-content-between mb-2">
        <span>Total Semua</span>
        <span class="fw-bold">{{ formatCurrency(grandTotal) }}</span>
      </div>
      <div class="d-flex justify-content-between mb-2">
        <span>Potongan Total</span>
        <span class="fw-bold">{{ formatCurrency(totalDiskon) }}</span>
      </div>
      <div class="d-flex justify-content-between mb-2">
        <span>Total Bayar</span>
        <span class="fw-bold text-success">{{ formatCurrency(totalBayar) }}</span>
      </div>

      <!-- INPUT PEMBAYARAN -->
      <div class="mb-2">
        <label>Cash Bayar:</label>
        <input type="number" v-model.number="bayarTunai" class="form-control form-control-sm" />
      </div>
      <div class="mb-2">
        <label>Non-Tunai Bayar:</label>
        <input type="number" v-model.number="bayarNonTunai" class="form-control form-control-sm" />
      </div>
      <div class="d-flex justify-content-between mb-3">
        <strong>Kembalian:</strong>
        <span class="fw-bold text-primary">{{ formatCurrency(kembalian) }}</span>
      </div>

      <!-- BUTTON CHECKOUT -->
      <div class="text-end">
        <button class="btn btn-success btn-sm"
                @click="checkout"
                :disabled="bayarTunai + bayarNonTunai < totalBayar">
          Checkout
        </button>
      </div>
    </div>

    <slot name="footer" />
  </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue'
import Swal from 'sweetalert2'
import axios from 'axios'

const props = defineProps({
  items: Array
})

const emit = defineEmits([
  'update:items', 
  'update', 
  'delete', 
  'refresh',
  'checkout' // tambahkan ini
])


const localItems = ref([...props.items])

watch(() => props.items, (val) => {
  localItems.value = [...val]
})

const onUpdate = (item) => {
  emit('update', item)
  emit('update:items', localItems.value)
}

// Format uang
const formatCurrency = (val) =>
  new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(val)

// Hitung total item
const hitungTotalItem = (item) => {
  const hargaTotal = item.unit_price * item.quantity
  const potongan = (item.discount || 0) / 100 * hargaTotal
  return hargaTotal - potongan
}

// Computed grand total
const grandTotal = computed(() =>
  localItems.value.reduce((sum, item) => sum + (item.unit_price * item.quantity), 0)
)

const totalDiskon = computed(() =>
  localItems.value.reduce((sum, item) => {
    const diskon = (item.discount || 0) / 100 * (item.unit_price * item.quantity)
    return sum + diskon
  }, 0)
)

const totalBayar = computed(() => grandTotal.value - totalDiskon.value)

const bayarTunai = ref(0)
const bayarNonTunai = ref(0)

const kembalian = computed(() => {
  const totalDibayar = bayarTunai.value + bayarNonTunai.value
  return totalDibayar - totalBayar.value
})

// Checkout logic
const checkout = () => {
  emit('checkout', {
    tunai: bayarTunai.value,
    nontunai: bayarNonTunai.value,
    total: totalBayar.value,
    kembalian: kembalian.value
  })
}

</script>
