<template>
  <h1>About Page</h1>
  <ul v-if="files.length > 0">
    <li v-for="file in files">
      {{ file }}
    </li>
  </ul>
  <p v-else>No file data - F5 to load server-side</p>
</template>

<script setup lang="ts">
// https://vuejs.org/guide/typescript/composition-api.html#typescript-with-composition-api

import { onServerPrefetch, Ref, ref, useSSRContext } from 'vue'
import { inject } from 'vue';
import { InitialDataKey } from '../util/InjectionKeys';

const counter = ref(0)
const files: Ref<string[]> = ref([])

if (!import.meta.env.SSR) {
  const initialData = inject(InitialDataKey)
  if (initialData) {
    files.value = initialData.files ?? []
  }
}
 
// https://vuejs.org/api/composition-api-lifecycle.html#onserverprefetch
onServerPrefetch(async() => {
  const ctx = useSSRContext()
  const ssrData = await import('../util/SSRData')
  const fs = await import('node:fs')
  files.value = fs.readdirSync('.')
  ssrData.addInitialData(ctx!, 'files', files.value)
})
</script>