<template>
  <div class="card-style mb-30">
    <slot name="header" />

    <!-- TABEL PRODUK -->
    <div class="table-responsive">
      <!-- Tabel untuk SALE -->
      <table class="table sell-order-table table-sm text-sm" v-if="mode === 'SALE'">
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
          <tr v-for="item in localItems" :key="item.idbarang">
            <td>{{ item.namabarang }}</td>
            <td>
              <input type="number" class="form-control form-control-sm" v-model.number="item.quantity" min="1" style="width: 70px;" @change="onUpdate(item)" />
            </td>
            <td>
              <input type="number" class="form-control form-control-sm" v-model.number="item.discount" min="0" max="100" style="width: 60px;" @change="onUpdate(item)" />
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

      <!-- Tabel untuk PURCHASE dan CONFIRM_PURCHASE -->
      <table class="table sell-order-table table-sm text-sm" v-if="['CONFIRM_PURCHASE', 'PURCHASE'].includes(mode)">
        <thead>
          <tr>
            <th><h6 class="text-sm fw-500">Produk</h6></th>
            <th><h6 class="text-sm fw-500">Jumlah</h6></th>
            <th><h6 class="text-sm fw-500">Pot. %</h6></th>
            <th><h6 class="text-sm fw-500">Pajak %</h6></th>
            <th><h6 class="text-sm fw-500">Harga Pokok</h6></th>
            <th v-if="mode === 'CONFIRM_PURCHASE'"><h6 class="text-sm fw-500">Batch</h6></th>
            <th v-if="mode === 'CONFIRM_PURCHASE'"><h6 class="text-sm fw-500">Kadaluarsa</h6></th>
            <th class="text-end"><h6 class="text-sm fw-500">Total</h6></th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="localItems.length === 0">
            <td :colspan="mode === 'CONFIRM_PURCHASE' ? 9 : 7" class="text-center text-sm text-gray">Belum ada produk ditambahkan.</td>
          </tr>
          <tr v-for="item in localItems" :key="item.idbarang">
            <td>{{ item.namabarang }}</td>
            <td>
              <input type="number" class="form-control form-control-sm" v-model.number="item.quantity" min="1" style="width: 70px;" @change="onUpdate(item)" />
            </td>
            <td>
              <input type="number" class="form-control form-control-sm" v-model.number="item.discount" min="0" max="100" style="width: 60px;" @change="onUpdate(item)" />
            </td>
            <td>
              <input type="number" class="form-control form-control-sm" v-model.number="item.tax" min="0" max="100" style="width: 60px;" @change="onUpdate(item)" />
            </td>
            <td>
              <input type="number" class="form-control form-control-sm" v-model.number="item.unit_price" min="0" style="width: 100px;" @change="onUpdate(item)" />
            </td>
            <td v-if="mode === 'CONFIRM_PURCHASE'">
              <input type="text" class="form-control form-control-sm" v-model="item.batch" @change="onUpdate(item)" />
            </td>
            <td v-if="mode === 'CONFIRM_PURCHASE'">
              <input type="date" class="form-control form-control-sm" v-model="item.expired" @change="onUpdate(item)" />
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
        <button class="btn btn-success btn-sm" @click="checkout" :disabled="bayarTunai + bayarNonTunai < totalBayar">
          {{label}}
        </button>
      </div>
    </div>

    <slot name="footer" />
  </div>
</template>


<script setup>
import { ref, watch, computed } from 'vue'

const props = defineProps({
  items: Array,
  mode: String
})

const label = computed(() => {
  switch (props.mode) {
    case 'SALE':
      return 'Checkout Penjualan'
    case 'PURCHASE':
      return 'Konfirmasi Pembelian'
    case 'CONFIRM_PURCHASE':
      return 'Checkout Penerimaan'
    default:
      return 'Checkout'
  }
})

const emit = defineEmits(['update:items', 'update', 'delete', 'refresh', 'checkout'])

const localItems = ref([...props.items])
watch(() => props.items, (val) => {
  localItems.value = [...val]
})

const onUpdate = (item) => {
  emit('update', item)
  emit('update:items', localItems.value)
}

const formatCurrency = (val) =>
  new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(val)

const hitungTotalItem = (item) => {
  const subtotal = item.unit_price * item.quantity
  const diskon = (item.discount || 0) / 100 * subtotal
  const setelahDiskon = subtotal - diskon
  const pajak = (item.tax || 0) / 100 * setelahDiskon
  return props.mode === 'PURCHASE' || props.mode === 'CONFIRM_PURCHASE' ? setelahDiskon + pajak : setelahDiskon
}

const grandTotal = computed(() =>
  localItems.value.reduce((sum, item) => {
    const subtotal = item.unit_price * item.quantity
    const diskon = (item.discount || 0) / 100 * subtotal
    const pajak = (item.tax || 0) / 100 * (subtotal - diskon)
    return sum + (props.mode === 'PURCHASE' || props.mode === 'CONFIRM_PURCHASE'
      ? subtotal - diskon + pajak
      : subtotal)
  }, 0)
)

const totalDiskon = computed(() =>
  localItems.value.reduce((sum, item) => {
    const subtotal = item.unit_price * item.quantity
    return sum + ((item.discount || 0) / 100 * subtotal)
  }, 0)
)

const totalBayar = computed(() => grandTotal.value)

const bayarTunai = ref(0)
const bayarNonTunai = ref(0)

const kembalian = computed(() => {
  const totalDibayar = bayarTunai.value + bayarNonTunai.value
  return totalDibayar - totalBayar.value
})

const checkout = () => {
  emit('checkout', {
    tunai: bayarTunai.value,
    nontunai: bayarNonTunai.value,
    total: totalBayar.value,
    kembalian: kembalian.value
  })
}
</script>

