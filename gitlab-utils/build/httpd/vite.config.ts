import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { configDefaults } from "vitest/config";
import tsconfigPaths from "vite-tsconfig-paths";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), tsconfigPaths()],
  test: {
    globals: true,
    environment: "jsdom",
    setupFiles: "./src/test-utils/setup.tsx",
    exclude: [...configDefaults.exclude],
    coverage: {
      ...configDefaults.coverage,
      provider: "v8",
      reporter: ["text", "lcov", "html"],
      all: true,
      include: ["src/**"],
      exclude: [
        ...configDefaults.coverage.exclude!,
        "src/main.tsx",
        "src/test-utils",
        "**/index.ts",
      ],
    },
  },
});
