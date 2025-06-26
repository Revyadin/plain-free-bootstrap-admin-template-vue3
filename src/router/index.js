import { createRouter, createWebHistory } from 'vue-router'
import DefaultLayout from '../layouts/DefaultLayout.vue'
import Dashboard from '../pages/Dashboard/index.vue'
import About from '../pages/About/index.vue'

import TableMaster from '../pages/TableMaster/index.vue'
import TableMasterUpsert from '../pages/TableMaster/upsert.vue'

const routes = [
  {
    path: '/',
    component: DefaultLayout,
    children: [
      { path: '', component: Dashboard },
      { path: 'about', component: About },
      { path: 'tablemaster', component: TableMaster },
      { path: 'tablemaster/insert', component: TableMasterUpsert },
      { path: 'tablemaster/update/:id', component: TableMasterUpsert, props: true }
    ]
  }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
