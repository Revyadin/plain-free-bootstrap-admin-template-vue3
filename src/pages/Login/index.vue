<template>
    <section class="signin-section">
      <div class="container-fluid">
        <div class="row g-0 auth-row">
          <div class="col-lg-6">
            <div class="auth-cover-wrapper bg-primary-100">
              <div class="auth-cover">
                <div class="title text-center">
                  <h1 class="text-primary mb-10">Welcome Back</h1>
                  <p class="text-medium">
                    Sign in to your Existing account to continue
                  </p>
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
          <!-- end col -->
          <div class="col-lg-6">
            <div class="signin-wrapper">
              <div class="form-wrapper">
                <h6 class="mb-15">Sign In Form</h6>
                <p class="text-sm mb-25">
                  Start creating the best possible user experience for you
                  customers.
                </p>
                <form action="#">
                  <div class="row">
                    <div class="col-12">
                      <div class="input-style-1">
                        <label>Email</label>
                        <input type="email" placeholder="Email">
                      </div>
                    </div>
                    <!-- end col -->
                    <div class="col-12">
                      <div class="input-style-1">
                        <label>Password</label>
                        <input type="password" placeholder="Password">
                      </div>
                    </div>
                    <!-- end col -->
                    <div class="col-xxl-6 col-lg-12 col-md-6">
                      <div class="form-check checkbox-style mb-30">
                        <input class="form-check-input" type="checkbox" value="" id="checkbox-remember">
                        <label class="form-check-label" for="checkbox-remember">
                          Remember me next time</label>
                      </div>
                    </div>
                    <!-- end col -->
                    <div class="col-xxl-6 col-lg-12 col-md-6">
                      <div class="text-start text-md-end text-lg-start text-xxl-end mb-30">
                        <a href="reset-password.html" class="hover-underline">
                          Forgot Password?
                        </a>
                      </div>
                    </div>
                    <!-- end col -->
                    <div class="col-12">
                      <div class="button-group d-flex justify-content-center flex-wrap">
                        <button class="main-btn primary-btn btn-hover w-100 text-center">
                          Sign In
                        </button>
                      </div>
                    </div>
                  </div>
                  <!-- end row -->
                </form>
                <div class="singin-option pt-40">
                  <p class="text-sm text-medium text-center text-gray">
                    Easy Sign In With
                  </p>
                  <div class="button-group pt-40 pb-40 d-flex justify-content-center flex-wrap">
                    <button class="main-btn primary-btn-outline m-2">
                      <i class="lni lni-facebook-fill mr-10"></i>
                      Facebook
                    </button>
                    <button class="main-btn danger-btn-outline m-2">
                      <i class="lni lni-google mr-10"></i>
                      Google
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
          <!-- end col -->
        </div>
        <!-- end row -->
      </div>
    </section>
</template>