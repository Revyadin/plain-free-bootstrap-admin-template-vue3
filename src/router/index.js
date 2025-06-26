import { createRouter, createWebHistory } from 'vue-router'
import DefaultLayout from '../layouts/DefaultLayout.vue'
import Dashboard from '../pages/Dashboard/index.vue'
import About from '../pages/About/index.vue'

const routes = [
  {
    path: '/',
    component: DefaultLayout,
    children: [
      { path: '', component: Dashboard },
      { path: 'about', component: About }
    ]
  }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
