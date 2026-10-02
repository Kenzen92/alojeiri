import react from '@vitejs/plugin-react';
import { defineConfig } from 'vitest/config';

// In dev, API calls go through the Vite proxy so the browser sees a single origin
// (mirrors production, where Caddy serves the SPA and proxies /api to Django).
export default defineConfig({
  plugins: [react()],
  server: {
    host: true,
    port: 5173,
    proxy: {
      '/api': {
        target: process.env.VITE_API_PROXY_TARGET ?? 'http://localhost:8000',
        changeOrigin: true,
      },
    },
  },
  test: {
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.ts'],
  },
});
