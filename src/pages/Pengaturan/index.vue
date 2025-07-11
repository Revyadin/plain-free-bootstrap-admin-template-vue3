<template>
  <div class="container-fluid">
    <TitlePage :title="title" />

    <!-- ========== form-layout-wrapper start ========== -->
    <div class="form-layout-wrapper">
      <div class="row">

        <!-- Form Informasi Usaha -->
        <div class="col-lg-6">
          <div class="card-style mb-30">
            <h6 class="mb-25">Informasi Usaha</h6>
            <form @submit.prevent>
              <div class="row">
                <div class="col-12">
                  <div class="input-style-1">
                    <label>Nama Usaha</label>
                    <input type="text" placeholder="Contoh: Toko Sejahtera" class="bg-transparent">
                  </div>
                </div>

                <div class="col-12">
                  <div class="input-style-1">
                    <label>Kontak</label>
                    <input type="text" placeholder="Contoh: 0812-3456-7890" class="bg-transparent">
                  </div>
                </div>

                <div class="col-12">
                  <div class="input-style-1">
                    <label>Alamat</label>
                    <textarea placeholder="Contoh: Jl. Raya No.123, Jakarta" rows="5" class="bg-transparent"></textarea>
                  </div>
                </div>

                <div class="col-12">
                  <button type="submit" class="main-btn primary-btn btn-hover">
                    Simpan Informasi
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
        <!-- end col -->

        <!-- Form Atribut Media -->
        <div class="col-lg-6">
          <div class="card-style mb-30">
            <h6 class="mb-15">Atribut Media</h6>
            <p class="text-sm mb-25">
              Unggah logo dan ikon untuk identitas usaha Anda.
            </p>

            <form @submit.prevent>
              <div class="row">
                <!-- Logo Utama -->
                <div class="col-12 mb-3">
                  <div class="input-style-1">
                    <label>Logo Utama (1:1)</label>
                    <div v-if="logo1">
                      <img :src="logo1Preview" alt="Logo Preview" class="img-thumbnail mb-2" style="max-height: 120px;" />
                    </div>
                    <input type="file" accept="image/*" @change="onFileChange($event, 'logo1')" />
                  </div>
                </div>

                <!-- Ikon -->
                <div class="col-12 mb-3">
                  <div class="input-style-1">
                    <label>Ikon Usaha (32x32)</label>
                    <div v-if="iconUsaha">
                      <img :src="iconPreview" alt="Icon Preview" class="img-thumbnail mb-2" style="max-height: 80px;" />
                    </div>
                    <input type="file" accept="image/*" @change="onFileChange($event, 'iconUsaha')" />
                  </div>
                </div>

                <!-- Logo Cetak -->
                <div class="col-12 mb-3">
                  <div class="input-style-1">
                    <label>Logo Cetak</label>
                    <div v-if="logoCetak">
                      <img :src="logoCetakPreview" alt="Cetak Preview" class="img-thumbnail mb-2" style="max-height: 120px;" />
                    </div>
                    <input type="file" accept="image/*" @change="onFileChange($event, 'logoCetak')" />
                  </div>
                </div>

                <div class="col-12">
                  <button type="submit" class="main-btn primary-btn btn-hover">
                    Simpan Atribut
                  </button>
                </div>
              </div>
            </form>
          </div>
        </div>
        <!-- end col -->

      </div>
    </div>
    <!-- ========== form-layout-wrapper end ========== -->
  </div>
</template>

<script setup>
import { ref } from 'vue'
import TitlePage from '../../layouts/TitlePage.vue'

const title = "Pengaturan Umum"

// File refs
const logo1 = ref(null)
const logo1Preview = ref(null)
const iconUsaha = ref(null)
const iconPreview = ref(null)
const logoCetak = ref(null)
const logoCetakPreview = ref(null)

// Handle image input and preview
const onFileChange = (event, type) => {
  const file = event.target.files[0]
  if (!file) return

  // 1. Cek tipe file
  const validTypes = ['image/jpeg', 'image/png', 'image/webp']
  if (!validTypes.includes(file.type)) {
    alert('File harus berupa gambar (jpg, png, webp)')
    return
  }

  // 2. Cek ukuran file
  const maxSize = type === 'iconUsaha' ? 200 * 1024 : 500 * 1024
  if (file.size > maxSize) {
    alert(`Ukuran file terlalu besar. Maksimal ${maxSize / 1024} KB`)
    return
  }

  const reader = new FileReader()
  reader.onload = () => {
    const img = new Image()
    img.onload = () => {
      // 3. Cek dimensi/rasio sesuai type
      if (type === 'logo1') {
        const ratio = img.width / img.height
        if (Math.abs(ratio - 1) > 0.05) {
          alert('Logo utama harus rasio 1:1')
          return
        }
      }

      if (type === 'iconUsaha') {
        if (img.width !== 32 || img.height !== 32) {
          alert('Ikon usaha harus berukuran 32x32 pixel')
          return
        }
      }

      // 4. Simpan hasil preview
      const result = reader.result
      switch (type) {
        case 'logo1':
          logo1.value = file
          logo1Preview.value = result
          break
        case 'iconUsaha':
          iconUsaha.value = file
          iconPreview.value = result
          break
        case 'logoCetak':
          logoCetak.value = file
          logoCetakPreview.value = result
          break
      }
    }
    img.src = reader.result
  }
  reader.readAsDataURL(file)
}

</script>

<style scoped>
.img-thumbnail {
  border-radius: 0.5rem;
  border: 1px solid #dee2e6;
  padding: 4px;
  background-color: #fff;
}
</style>
