/// <reference types="vite/client" />

interface ImportMetaEnv {
  VITE_LOG_LEVEL: string
  OLLAMA_API_BASE_URL: string
  OPENAI_LIKE_API_BASE_URL: string
  OPENAI_LIKE_API_KEY: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
} 