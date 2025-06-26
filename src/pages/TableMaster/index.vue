<template>
    <section class="table-components">
        <div class="container-fluid">
            <div class="title-wrapper pt-30">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <div class="title">
                            <h2>Tables</h2>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="breadcrumb-wrapper">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item">
                                        <a href="#0">Dashboard</a>
                                    </li>
                                    <li class="breadcrumb-item active" aria-current="page">
                                        Tables
                                    </li>
                                </ol>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tables-wrapper">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="card-style mb-30">
                            <h6 class="mb-10">Responsive Data Table</h6>
                            <div class="d-flex flex-wrap justify-content-between align-items-center py-3">
                                <div class="left d-flex align-items-center gap-3">
                                    <router-link :to="addPath" class="btn btn-primary">Insert</router-link>
                                    <p>Show <span>10</span> entries</p>
                                </div>
                                <div class="right">
                                    <div class="table-search d-flex">
                                        <form @submit.prevent>
                                            <input type="text" placeholder="Search..." v-model="searchQuery" />
                                            <button><i class="lni lni-search-alt"></i></button>
                                        </form>
                                    </div>
                                </div>
                            </div>


                            <div class="table-wrapper table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th class="lead-info">
                                                <h6>Lead</h6>
                                            </th>
                                            <th class="lead-email">
                                                <h6>Email</h6>
                                            </th>
                                            <th class="lead-phone">
                                                <h6>Phone No</h6>
                                            </th>
                                            <th class="lead-company">
                                                <h6>Company</h6>
                                            </th>
                                            <th>
                                                <h6>Action</h6>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="(lead, index) in filteredLeads" :key="index">
                                            <td>
                                                <div class="lead">
                                                    <div class="lead-image">
                                                        <img :src="lead.image" alt="" />
                                                    </div>
                                                    <div class="lead-text">
                                                        <p>{{ lead.name }}</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <p><a href="#0">{{ lead.email }}</a></p>
                                            </td>
                                            <td>
                                                <p>{{ lead.phone }}</p>
                                            </td>
                                            <td>
                                                <p>{{ lead.company }}</p>
                                            </td>
                                            <td>
                                                <div class="action d-flex gap-2">
                                                    <button class="text-primary">
                                                        <i class="lni lni-pencil" @click="handleUpdate(lead.id)"></i>
                                                    </button>
                                                    <button class="text-danger" @click="handleDelete(lead)">
                                                        <i class="lni lni-trash-can"></i>
                                                    </button>
                                                </div>
                                            </td>

                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="pt-10 d-flex flex-wrap gap-3 justify-content-between">
                                <div class="left">
                                    <p class="text-sm text-gray">Showing 12/30 products</p>
                                </div>
                                <div class="right table-pagination">
                                    <ul class="d-flex justify-content-end align-items-center gap-2">
                                        <li><a href="#0"><i class="lni lni-angle-double-left"></i></a></li>
                                        <li><a href="#0">1</a></li>
                                        <li><a href="#0" class="active">2</a></li>
                                        <li><a href="#0">3</a></li>
                                        <li><a href="#0">4</a></li>
                                        <li><a href="#0"><i class="lni lni-angle-double-right"></i></a></li>
                                    </ul>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="warning-modal" v-if="showModal">
        <div class="modal fade show" id="ModalTwo" tabindex="-1" style="display: block;" aria-modal="true" role="dialog">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content card-style warning-card text-center">
                    <div class="modal-body">
                        <div class="icon text-danger mb-20">
                            <i class="lni lni-warning"></i>
                        </div>
                        <div class="content mb-30">
                            <h2 class="mb-15">Warning!</h2>
                            <p class="text-sm text-medium">
                                Are you sure you want to delete <strong>{{ selectedLead?.name }}</strong>?
                            </p>
                        </div>
                        <div class="action d-flex flex-wrap justify-content-center">
                            <button @click="closeModal" class="main-btn btn-sm danger-btn rounded-full btn-hover m-1">
                                Close
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
const route = useRoute()
const router = useRouter()
const addPath = computed(() => `${route.path.replace(/\/$/, '')}/insert`)

const searchQuery = ref('')
const showModal = ref(false)
const selectedLead = ref(null)

const leads = ref([
  {
    id: 1,
    name: 'Courtney Henry',
    image: '/assets/images/lead/lead-1.png',
    email: 'yourmail@gmail.com',
    phone: '(303)555 3343523',
    company: 'UIdeck digital agency',
  },
  {
    id: 2,
    name: 'John Doe',
    image: '/assets/images/lead/lead-2.png',
    email: 'yourmail@gmail.com',
    phone: '(303)555 3343523',
    company: 'Graygrids digital agency',
  },
  {
    id: 3,
    name: 'David Smith',
    image: '/assets/images/lead/lead-3.png',
    email: 'yourmail@gmail.com',
    phone: '(303)555 3343523',
    company: 'Abc agency',
  },
  {
    id: 4,
    name: 'Jonathon',
    image: '/assets/images/lead/lead-4.png',
    email: 'yourmail@gmail.com',
    phone: '(303)555 3343523',
    company: 'Creative IT Agency',
  },
  {
    id: 5,
    name: 'Anna Lee',
    image: '/assets/images/lead/lead-5.png',
    email: 'yourmail@gmail.com',
    phone: '(303)555 3343523',
    company: 'Halal It agency',
  },
  {
    id: 6,
    name: 'Gray Simon',
    image: '/assets/images/lead/lead-6.png',
    email: 'yourmail@gmail.com',
    phone: '(303)555 3343523',
    company: 'DesignCourse',
  },
]);


const filteredLeads = computed(() => {
    if (!searchQuery.value) return leads.value
    const query = searchQuery.value.toLowerCase()
    return leads.value.filter(
        (lead) =>
            lead.name.toLowerCase().includes(query) ||
            lead.email.toLowerCase().includes(query) ||
            lead.phone.toLowerCase().includes(query) ||
            lead.company.toLowerCase().includes(query)
    )
})

const handleDelete = (lead) => {
    selectedLead.value = lead
    showModal.value = true
}

const handleUpdate = (id) => {
  const basePath = route.path.replace(/\/$/, '')
  router.push(`${basePath}/update/${id}`)
}

const closeModal = () => {
    selectedLead.value = null
    showModal.value = false
}
</script>
