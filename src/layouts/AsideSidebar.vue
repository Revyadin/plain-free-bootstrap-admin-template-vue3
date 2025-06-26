<template>
  <aside :class="['sidebar-nav-wrapper', { active: isSidebarActive }]">
    <div class="navbar-logo">
      <a href="index.html">
        <img src="/assets/images/logo/logo.svg" alt="logo" />
      </a>
    </div>
    <nav class="sidebar-nav">
      <ul>
        <template v-for="(item, index) in menuItems" :key="index">
          <li v-if="item.divider" class="divider">
            <hr />
          </li>
          <li
            v-else-if="item.isDropdown"
            class="nav-item nav-item-has-children"
            :class="{ show: openMenu === item.text }"
          >
            <a href="#0" class="collapsed" @click.prevent="toggleMenu(item.text)">
              <span class="icon"><i :class="item.icon"></i></span>
              <span v-if="!collapsed" class="text">{{ item.text }}</span>
            </a>
            <ul class="collapse dropdown-nav" :class="{ show: openMenu === item.text }">
              <li v-for="(child, childIndex) in item.children" :key="childIndex">
                <a :href="child.link" :class="{ active: child.active }">
                  {{ child.text }}
                </a>
              </li>
            </ul>
          </li>
          <li v-else class="nav-item">
            <a :href="item.link">
              <span class="icon"><i :class="item.icon"></i></span>
              <span v-if="!collapsed" class="text">{{ item.text }}</span>
            </a>
          </li>
        </template>
      </ul>
    </nav>
    <div class="promo-box" v-if="!collapsed">
      <div class="promo-icon">
        <img class="mx-auto" src="/assets/images/logo/logo-icon-big.svg" alt="Logo" />
      </div>
      <h3>Upgrade to PRO</h3>
      <p>
        Improve your development process and start doing more with PlainAdmin PRO!
      </p>
      <a
        href="https://plainadmin.com/pro"
        target="_blank"
        rel="nofollow"
        class="main-btn primary-btn btn-hover"
      >
        Upgrade to PRO
      </a>
    </div>
  </aside>

  <div @click="toggleSidebar" :class="['overlay', { active: isSidebarActive }]"></div>
</template>

<script setup>
import { ref, inject } from 'vue'

// Inject global state
const isSidebarActive = inject('isSidebarActive')
const toggleSidebar = inject('toggleSidebar')

// Collapsed state (bisa diatur dinamis kalau mau)
const collapsed = ref(false)

// Menyimpan menu yang sedang dibuka
const openMenu = ref(null)

// Fungsi toggle
function toggleMenu(menuText) {
  openMenu.value = openMenu.value === menuText ? null : menuText
}

// Menu item list
const menuItems = ref([
  {
    text: "Etalase",
    icon: "mdi mdi-store",
    link: "etalase",
  },
  { divider: true },
  {
    text: "Dashboard",
    icon: "mdi mdi-view-dashboard",
    link: "dashboard",
  },
  {
    text: "Pembelian Barang",
    icon: "mdi mdi-cart",
    link: "pembelian-barang",
  },
  { divider: true },
  {
    text: "Master Data",
    icon: "mdi mdi-database",
    isDropdown: true,
    children: [
      { text: "Supplier", link: "index.html", active: true },
      { text: "Pengguna", link: "users.html" },
      { text: "Barang", link: "products.html" },
      { text: "Satuan", link: "categories.html" },
    ],
  },
  {
    text: "Transaksi",
    icon: "mdi mdi-swap-horizontal",
    isDropdown: true,
    children: [
      { text: "Pembatalan Pembelian", link: "index.html" },
      { text: "Pembatalan Penjualan", link: "users.html" },
      { text: "Penyesuaian Stok", link: "products.html" },
      { text: "Transfer Stok", link: "categories.html" },
      { text: "Retur Pembelian", link: "index.html" },
      { text: "Retur Penjualan", link: "users.html" },
    ],
  },
  {
    text: "Laporan",
    icon: "mdi mdi-file-document",
    isDropdown: true,
    children: [
      { text: "Laporan Pembelian", link: "index.html" },
      { text: "Laporan Penjualan", link: "users.html" },
      { text: "Laporan Barang", link: "products.html" },
      { text: "Laporan Stok", link: "categories.html" },
      { text: "Laporan Keuangan", link: "index.html" },
      { text: "Laporan Kartu Stok", link: "users.html" },
    ],
  },
  {
    text: "Pengaturan",
    icon: "mdi mdi-cog",
    isDropdown: true,
    children: [
      { text: "Pengaturan Umum", link: "index.html" },
      { text: "Pengaturan Sistem", link: "users.html" },
      { text: "Pengaturan Lainnya", link: "products.html" },
    ],
  },
  { divider: true },
  {
    text: "Keluar",
    icon: "mdi mdi-logout",
    link: "login.html",
  },
  {
    text: "Tentang",
    icon: "mdi mdi-information",
    link: "about.html",
  },
  {
    text: "Bantuan",
    icon: "mdi mdi-help-circle",
    link: "help.html",
  },
  {
    text: "Kontak",
    icon: "mdi mdi-email",
    link: "contact.html",
  },
  { divider: true },
  {
    text: "Upgrade to PRO",
    icon: "mdi mdi-star",
    link: "https://plainadmin.com/pro",
    isExternal: true,
  },
])
</script>

<style scoped>

</style>
