import { createRouter, createWebHistory } from 'vue-router'

// Pages
import Login from '../pages/Auth/login.vue'
import Dashboard from '../pages/Dashboard/index.vue'
import About from '../pages/About/index.vue'
import TableMaster from '../pages/TableMaster/index.vue'

// Lazy Load Pages
const Transaksi = () => import('../pages/Transaksi/index.vue')
const Supplier = () => import('../pages/Supplier/index.vue')
const Users = () => import('../pages/Users/index.vue')
const Products = () => import('../pages/Products/index.vue')
const LaporanPenjualan = () => import('../pages/Laporan/Penjualan/index.vue')
const LaporanPembelian = () => import ('../pages/Laporan/Pembelian/index.vue')
const Penerimaan = () => import ('../pages/Penerimaan/index.vue')
const DetailPenerimaan = () => import ('../pages/Penerimaan/detail.vue')
const NotFound = () => import ('../pages/Notfound/index.vue')
const PengaturanUmum = () => import ('../pages/Pengaturan/index.vue')
const routes = [
  // --- Auth Layout (Tanpa Sidebar/Topbar)
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: {
      title: 'Login',
      layout: 'auth',
      requiresAuth: false
    }
  },

  // --- Default Layout
  {
    path: '/',
    redirect: '/dashboard'
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: Dashboard,
    meta: {
      title: 'Dashboard',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/about',
    name: 'About',
    component: About,
    meta: {
      title: 'Tentang Kami',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/penjualan',
    name: 'Penjualan',
    component: Transaksi,
    meta: {
      title: 'Penjualan',
      layout: 'default',
      requiresAuth: true,
      transactionType: 'SALE'
    }
  },
  {
    path: '/pembelian',
    name: 'Pembelian',
    component: Transaksi,
    meta: {
      title: 'Pembelian',
      layout: 'default',
      requiresAuth: true,
      transactionType: 'PURCHASE'
    }
  },

  // Table Master
  {
    path: '/tablemaster',
    name: 'TableMaster',
    component: TableMaster,
    meta: {
      title: 'Table Master',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/tablemaster/insert',
    name: 'InsertTableMaster',
    component: TableMaster,
    meta: {
      title: 'Tambah Table Master',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/tablemaster/update/:id',
    name: 'UpdateTableMaster',
    component: TableMaster,
    meta: {
      title: 'Edit Table Master',
      layout: 'default',
      requiresAuth: true
    }
  },

  // Supplier
  {
    path: '/supplier',
    name: 'Supplier',
    component: Supplier,
    meta: {
      title: 'Data Supplier',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/supplier/insert',
    name: 'InsertSupplier',
    component: Supplier,
    meta: {
      title: 'Tambah Supplier',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/supplier/update/:id',
    name: 'UpdateSupplier',
    component: Supplier,
    meta: {
      title: 'Edit Supplier',
      layout: 'default',
      requiresAuth: true
    }
  },

  // Users
  {
    path: '/users',
    name: 'Users',
    component: Users,
    meta: {
      title: 'Data Pengguna',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/users/insert',
    name: 'InsertUser',
    component: Users,
    meta: {
      title: 'Tambah Pengguna',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/users/update/:id',
    name: 'UpdateUser',
    component: Users,
    meta: {
      title: 'Edit Pengguna',
      layout: 'default',
      requiresAuth: true
    }
  },

  // Products
  {
    path: '/products',
    name: 'Products',
    component: Products,
    meta: {
      title: 'Data Produk',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/products/insert',
    name: 'InsertProduct',
    component: Products,
    meta: {
      title: 'Tambah Produk',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/products/update/:id',
    name: 'UpdateProduct',
    component: Products,
    meta: {
      title: 'Edit Produk',
      layout: 'default',
      requiresAuth: true
    }
  },

  // Laporan
  {
    path: '/laporan/penjualan',
    name: 'LaporanPenjualan',
    component: LaporanPenjualan,
    meta: {
      title: 'Laporan Penjualan',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/laporan/penjualan/:id',
    name: 'DetailLaporanPenjualan',
    component: LaporanPenjualan,
    meta: {
      title: 'Detail Penjualan',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/laporan/pembelian',
    name: 'LaporanPembelian',
    component: LaporanPembelian,
    meta: {
      title: 'Laporan Pembelian',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/laporan/pembelian/:id',
    name: 'DetailLaporanPembelian',
    component: LaporanPembelian,
    meta: {
      title: 'Detail Pembelian',
      layout: 'default',
      requiresAuth: true
    }
  },
  {
    path: '/penerimaan-pembelian',
    name: 'Penerimaan Pembelian',
    component: Penerimaan,
    meta: {
      title: 'Tabel Penerimaan',
      layout: 'default',
      requiresAuth: true,
      transactionType: 'CONFIRM_PURCHASE'
    }
  },
  {
    path: '/penerimaan-pembelian/:id',
    name: 'Detail Penerimaan Pembelian',
    component: DetailPenerimaan,
    meta: {
      title: 'Tabel Detail Penerimaan',
      layout: 'default',
      requiresAuth: true,
      transactionType: 'CONFIRM_PURCHASE'
    }
  },

  {
    path: '/pengaturan-umum',
    name: 'Pengaturan Umum',
    component: PengaturanUmum,
    meta: {
      title: 'Pengaturan Umum',
      layout: 'default',
      requiresAuth: true
    }
  },

  {
    path: '/404',
    name: 'Not Found',
    component: NotFound
  },


  // Fallback
  {
    path: '/:catchAll(.*)',
    redirect: '/404'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
