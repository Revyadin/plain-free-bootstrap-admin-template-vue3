import { createRouter, createWebHistory } from 'vue-router'
import DefaultLayout from '../layouts/DefaultLayout.vue'
import Dashboard from '../pages/Dashboard/index.vue'
import About from '../pages/About/index.vue'

import TableMaster from '../pages/TableMaster/index.vue'



const routes = [
  {
    path: '/',
    component: DefaultLayout,
    children: [
      { path: 'dashboard', component: Dashboard },
      { path: 'etalase', component: () => import('../pages/Etalase/index.vue') },
      
      { path: 'about', component: About },
      { path: 'tablemaster', component: TableMaster },
      { path: 'tablemaster/insert', component: TableMaster },
      { path: 'tablemaster/update/:id', component: TableMaster },

      { path: 'pembelian-barang', component: Dashboard },
      { path: 'login', component: Dashboard },
      { path: 'help', component: Dashboard },
      { path: 'contact', component: Dashboard },

      { path : 'supplier', component: () => import('../pages/Supplier/index.vue') },
      { path : 'supplier/insert', component: () => import('../pages/Supplier/index.vue') },
      { path : 'supplier/update/:id', component: () => import('../pages/Supplier/index.vue') },

      { path : 'users', component: () => import('../pages/Users/index.vue') },
      { path : 'users/insert', component: () => import('../pages/Users/index.vue') },
      { path : 'users/update/:id', component: () => import('../pages/Users/index.vue') },

      { path : 'products', component: () => import('../pages/Products/index.vue') },
      { path : 'products/insert', component: () => import('../pages/Products/index.vue') },
      { path : 'products/update/:id', component: () => import('../pages/Products/index.vue') },

      { path : 'laporan/penjualan', component: () => import('../pages/Laporan/Penjualan/index.vue') },
      { path : 'laporan/penjualan/:id', component: () => import('../pages/Laporan/Penjualan/index.vue') },
    ]
  }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
