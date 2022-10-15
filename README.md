# Vue 3 + TypeScript + Vite + SSR + Tailwind

This template should help get you started developing with Vue 3 SSR and TypeScript in Vite. The template uses Vue 3 `<script setup>` SFCs, check out the [script setup docs](https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup) to learn more.

## Recommended IDE Setup

- [VS Code](https://code.visualstudio.com/) + [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar)

## Type Support For `.vue` Imports in TS

Since TypeScript cannot handle type information for `.vue` imports, they are shimmed to be a generic Vue component type by default. In most cases this is fine if you don't really care about component prop types outside of templates. However, if you wish to get actual prop types in `.vue` imports (for example to get props validation when using manual `h(...)` calls), you can enable Volar's Take Over mode by following these steps:

1. Run `Extensions: Show Built-in Extensions` from VS Code's command palette, look for `TypeScript and JavaScript Language Features`, then right click and select `Disable (Workspace)`. By default, Take Over mode will enable itself if the default TypeScript extension is disabled.
2. Reload the VS Code window by running `Developer: Reload Window` from the command palette.

You can learn more about Take Over mode [here](https://github.com/johnsoncodehk/volar/discussions/471).

## SSR Setup Notes
### Standard vue-ts Project create
```
npm create vite@latest vite-vue-ssr-template -- --template vue-ts

Scaffolding project in C:\Users\Iain\typescript\vite-examples\vite-vue-ssr-template...

Done. Now run:

  cd vite-vue-ssr-template
  npm install
  npm run dev

```

### Add tailwind
```
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```
Edit tailwind.config.cjs:
```
  content: [
    "./index.html",
    "./src/**/*.{ts,vue}"
  ],
```

### Copy in SSR-related files
 - server.ts
 - src/entry-client.ts
 - src/entry-server.ts
 - src/router.ts
 - src/util/InjectionKeys.ts
 - src/util/SSRData.ts
 - tsconfig-server.json

### Modify main.ts
```
import { createSSRApp } from 'vue'
import App from './App.vue'
import { createRouter } from './router'
import { InitialDataKey } from './util/InjectionKeys'

declare global {
  interface Window { INITIAL_DATA: Record<string, any>; }
}

// SSR requires a fresh app instance per request, therefore we export a function
// that creates a fresh app instance. If using Vuex, we'd also be creating a
// fresh store here.
export function createApp() {
  const app = createSSRApp(App)
  if (!import.meta.env.SSR) {
    app.provide(InitialDataKey, window.INITIAL_DATA)
  }
  const router = createRouter()
  app.use(router)
  return { app, router }
}

```

### Modify index.html
Add injection points for server-rendered html
```
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Vite + Vue + TS</title>
    <!--preload-links-->
    <script>
      window.INITIAL_DATA = '__INITIAL_DATA__'
    </script>
  </head>
  <body>    
    <div id="app"><!--app-html--></div>
    <script type="module" src="/src/entry-client.ts"></script>
  </body>
</html>
```

### Add additional deps
```
npm i vue-router express compression
npm i -D @types/express @types/compression @types/node cross-env ts-node
```

### Modify scripts in package.json
```
  "scripts": {
    "dev": "ts-node-esm server.ts",
    "build": "npm run build:client && npm run build:server",
    "build:client": "vite build --outDir dist/client --ssrManifest",
    "build:server": "vite build --outDir dist/server --ssr src/entry-server.ts",
    "build:express": "tsc --p ./tsconfig-server.json",
    "preview": "vite preview",
    "serve": "cross-env NODE_ENV=production node server"
  },
```