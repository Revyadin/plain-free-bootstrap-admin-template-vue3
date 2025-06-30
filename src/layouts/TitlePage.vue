<template>
    <div class="title-wrapper pt-30">
        <div class="row align-items-center">
            <div class="col-md-6">
                <div class="title">
                    <h2>{{ title }}</h2>
                </div>
            </div>
            <!-- end col -->
            <div class="col-md-6">
                <div class="breadcrumb-wrapper">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <!-- route to root -->
                                <RouterLink to="/dashboard">Dashboard</RouterLink>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">
                                {{ title }}
                            </li>
                        </ol>
                    </nav>
                </div>
            </div>
            <!-- end col -->
        </div>
        <!-- end row -->
    </div>
</template>
<script setup>
import { RouterLink } from 'vue-router';

// add prop for title
defineProps({
    title: {
        type: String,
        default: 'Title Page'
    }
});
</script>