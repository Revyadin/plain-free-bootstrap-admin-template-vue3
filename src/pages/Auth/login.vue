<template>
  <section class="signin-section">
    <div class="container-fluid">
      <div class="row g-0 auth-row">
        <div class="col-lg-6">
          <!-- Cover Side -->
          <div class="auth-cover-wrapper bg-primary-100">
            <div class="auth-cover">
              <div class="title text-center">
                <h1 class="text-primary mb-10">Welcome Back</h1>
                <p class="text-medium">Sign in to your Existing account to continue</p>
              </div>
              <div class="cover-image">
                <img src="https://demo.plainadmin.com/assets/images/auth/signin-image.svg" alt="">
              </div>
              <div class="shape-image">
                <img src="https://demo.plainadmin.com/assets/images/auth/shape.svg" alt="">
              </div>
            </div>
          </div>
        </div>

        <div class="col-lg-6">
          <!-- Form Side -->
          <div class="signin-wrapper">
            <div class="form-wrapper">
              <h6 class="mb-15">Sign In Form</h6>
              <p class="text-sm mb-25">Start creating the best possible user experience for your customers.</p>
              <form @submit.prevent="handleLogin">
                <div class="row">
                  <div class="col-12">
                    <div class="input-style-1">
                      <label>Email</label>
                      <input type="email" v-model="email" required placeholder="Email">
                    </div>
                  </div>
                  <div class="col-12">
                    <div class="input-style-1">
                      <label>Password</label>
                      <input type="password" v-model="password" required placeholder="Password">
                    </div>
                  </div>
                  <div class="col-12">
                    <div class="button-group d-flex justify-content-center flex-wrap">
                      <button type="submit" class="main-btn primary-btn btn-hover w-100 text-center">
                        Sign In
                      </button>
                    </div>
                  </div>
                </div>
              </form>

              <div class="singin-option pt-40">
                <p class="text-sm text-medium text-center text-gray">Easy Sign In With</p>
                <div class="button-group pt-40 pb-40 d-flex justify-content-center flex-wrap">
                  <button class="main-btn primary-btn-outline m-2">
                    <i class="lni lni-facebook-fill mr-10"></i> Facebook
                  </button>
                  <button class="main-btn danger-btn-outline m-2">
                    <i class="lni lni-google mr-10"></i> Google
                  </button>
                </div>
                <p class="text-sm text-medium text-dark text-center">
                  Don’t have any account yet?
                  <a href="signup.html">Create an account</a>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'

// Reactive form fields
const email = ref('')
const password = ref('')

// Login handler
const handleLogin = async () => {
  try {
    const response = await axios.post(
      `${import.meta.env.VITE_API_BASE_URL}/auth/signin`,
      { email: email.value, password: password.value }
    )

    const auth = response.data?.data
    // Simpan token ke localStorage / cookie
    localStorage.setItem('auth', JSON.stringify(auth))

    // Redirect atau tampilkan notifikasi
    Swal.fire('Sukses', response.data.message, 'success')
    // misalnya redirect
    window.location.href = '/dashboard'
  } catch (error) {
    console.log(error)
    Swal.fire('Gagal', error?.response?.data?.message, 'error')
  }
}
</script>
