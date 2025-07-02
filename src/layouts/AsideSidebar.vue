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
          <li v-else-if="item.isDropdown"
            :class="['nav-item nav-item-has-children', { active: item.active, show: openMenu === item.text }]">

            <a href="#0" class="collapsed" @click.prevent="toggleMenu(item.text)">
              <span class="icon"><i :class="item.icon"></i></span>
              <span v-if="!collapsed" class="text">{{ item.text }}</span>
            </a>
            <ul class="collapse dropdown-nav show" :class="{ show: openMenu === item.text }">
              <li v-for="(child, childIndex) in item.children" :key="childIndex">
                <a :href="child.link" :class="{ active: child.active }">
                  {{ child.text }}
                </a>
              </li>
            </ul>
          </li>
          <li v-else class="nav-item" :class="{ active: item.active }" :target="item.isExternal ? '_blank' : '_self'">
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
      <a href="https://plainadmin.com/pro" target="_blank" rel="nofollow" class="main-btn primary-btn btn-hover">
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
    text: "Penjualan",
    icon: "mdi mdi-store",
    link: "penjualan",
    active: false,
  },
  { divider: true },
  {
    text: "Dashboard",
    icon: "mdi mdi-view-dashboard",
    link: "dashboard",
    active: true,
  },
  {
    text: "Pembelian Barang",
    icon: "mdi mdi-cart",
    link: "pembelian-barang",
    active: false,
  },
  { divider: true },
  {
    text: "Master Data",
    icon: "mdi mdi-database",
    isDropdown: true,
    children: [
      { text: "Supplier", link: "supplier", active: false },
      { text: "Pengguna", link: "users" },
      { text: "Barang", link: "products" },
    ],
    active: false,
  },
  {
    text: "Transaksi",
    icon: "mdi mdi-swap-horizontal",
    isDropdown: true,
    children: [
      { text: "Pembatalan Pembelian", link: "index" },
      { text: "Pembatalan Penjualan", link: "users" },
      { text: "Penyesuaian Stok", link: "products" },
      { text: "Transfer Stok", link: "categories" },
      { text: "Retur Pembelian", link: "index" },
      { text: "Retur Penjualan", link: "users" },
    ],
    active: false,
  },
  {
    text: "Laporan",
    icon: "mdi mdi-file-document",
    isDropdown: true,
    children: [
      { text: "Laporan Pembelian", link: "index" },
      { text: "Laporan Penjualan", link: "laporan/penjualan" },
      { text: "Laporan Barang", link: "products" },
      { text: "Laporan Stok", link: "categories" },
      { text: "Laporan Keuangan", link: "index" },
      { text: "Laporan Kartu Stok", link: "users" },
    ],
    active: false,
  },
  {
    text: "Pengaturan",
    icon: "mdi mdi-cog",
    isDropdown: true,
    children: [
      { text: "Pengaturan Umum", link: "index" },
      { text: "Pengaturan Sistem", link: "users" },
      { text: "Pengaturan Lainnya", link: "products" },
    ],
    active: false,
  },
  { divider: true },
  {
    text: "Keluar",
    icon: "mdi mdi-logout",
    link: "login.html",
    active: false,
  },
  {
    text: "Tentang",
    icon: "mdi mdi-information",
    link: "about.html",
    active: false,
  },
  {
    text: "Bantuan",
    icon: "mdi mdi-help-circle",
    link: "help.html",
    active: false,
  },
  {
    text: "Kontak",
    icon: "mdi mdi-email",
    link: "contact.html",
    active: false,
  },
  { divider: true },
  {
    text: "Upgrade to PRO",
    icon: "mdi mdi-star",
    link: "https://plainadmin.com/pro",
    isExternal: true,
    active: false,
  },
])
</script>

<style scoped></style>
