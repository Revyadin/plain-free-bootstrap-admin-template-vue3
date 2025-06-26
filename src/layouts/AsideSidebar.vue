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
    text: "Dashboard",
    icon: "mdi mdi-view-dashboard",
    isDropdown: true,
    children: [{ text: "eCommerce", link: "index.html", active: true }],
  },
   {
    text: "Table master",
    icon: "mdi mdi-view-dashboard",
    link: "tablemaster",
  },
  {
    text: "Pages",
    icon: "mdi mdi-file-document-outline",
    isDropdown: true,
    children: [
      { text: "Settings", link: "settings.html" },
      { text: "Blank Page", link: "blank-page.html" },
    ],
  },
  {
    text: "Invoice",
    icon: "mdi mdi-receipt",
    link: "invoice.html",
  },
  {
    text: "Auth",
    icon: "mdi mdi-account-lock",
    isDropdown: true,
    children: [
      { text: "Sign In", link: "signin.html" },
      { text: "Sign Up", link: "signup.html" },
    ],
  },
  {
    divider: true,
  },
  {
    text: "UI Elements",
    icon: "mdi mdi-palette",
    isDropdown: true,
    children: [
      { text: "Alerts", link: "alerts.html" },
      { text: "Buttons", link: "buttons.html" },
      { text: "Cards", link: "cards.html" },
      { text: "Typography", link: "typography.html" },
    ],
  },
  {
    text: "Icons",
    icon: "mdi mdi-star-circle-outline",
    isDropdown: true,
    children: [
      { text: "LineIcons", link: "icons.html" },
      { text: "MDI Icons", link: "mdi-icons.html" },
    ],
  },
  {
    text: "Forms",
    icon: "mdi mdi-form-select",
    isDropdown: true,
    children: [
      { text: "Form Elements", link: "form-elements.html" },
    ],
  },
  {
    text: "Tables",
    icon: "mdi mdi-table",
    link: "tables.html",
  },
  {
    divider: true,
  },
  {
    text: "Notifications",
    icon: "mdi mdi-bell-outline",
    link: "notification.html",
  },
])
</script>

<style scoped>

</style>
