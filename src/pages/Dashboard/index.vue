<template>
  <section class="section">
    <div class="container-fluid">
      <TitlePage title="Dashboard" />
      <div class="row">
        <div class="col-xl-3 col-lg-4 col-sm-6">
          <div class="icon-card mb-30">
            <div class="icon purple">
              <i class="lni lni-users"></i>
            </div>
            <div class="content">
              <h6 class="mb-10">Users</h6>
              <h3 class="text-bold mb-10">6453</h3>
              <p class="text-sm text-success">
                <i class="lni lni-arrow-up"></i> +23.4%
              </p>
            </div>
          </div>
          <!-- End Icon Cart -->
        </div>
        <!-- End Col -->
        <div class="col-xl-3 col-lg-4 col-sm-6">
          <div class="icon-card mb-30">
            <div class="icon success">
              <i class="lni lni-eye"></i>
            </div>
            <div class="content">
              <h6 class="mb-10">Page views</h6>
              <h3 class="text-bold mb-10">876</h3>
              <p class="text-sm text-danger">
                <i class="lni lni-arrow-down"></i> -12.00%
              </p>
            </div>
          </div>
          <!-- End Icon Cart -->
        </div>
        <!-- End Col -->
        <div class="col-xl-3 col-lg-4 col-sm-6">
          <div class="icon-card mb-30">
            <div class="icon primary">
              <i class="lni lni-thumbs-up"></i>
            </div>
            <div class="content">
              <h6 class="mb-10">Impressions</h6>
              <h3 class="text-bold mb-10">976</h3>
              <p class="text-sm text-danger">
                <i class="lni lni-arrow-down"></i> -2.00%
              </p>
            </div>
          </div>
          <!-- End Icon Cart -->
        </div>
        <!-- End Col -->
        <div class="col-xl-3 col-lg-4 col-sm-6">
          <div class="icon-card mb-30">
            <div class="icon orange">
              <i class="lni lni-pie-chart"></i>
            </div>
            <div class="content">
              <h6 class="mb-10">Bounce Rate</h6>
              <h3 class="text-bold mb-10">346</h3>
              <p class="text-sm text-success">
                <i class="lni lni-arrow-up"></i> +23.4%
              </p>
            </div>
          </div>
          <!-- End Icon Cart -->
        </div>
        <!-- End Col -->
      </div>
    </div>
  </section>
</template>

<script setup>
import TitlePage from '../../layouts/TitlePage.vue';

</script>