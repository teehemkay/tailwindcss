import { defineConfig } from 'tsup'

export default defineConfig({
  format: ['cjs'],
  clean: true,
  minify: false,
  sourcemap: true,
  entry: ['src/index.ts'],
})
