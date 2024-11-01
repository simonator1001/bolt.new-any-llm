import type { ModelInfo, OllamaApiResponse, OllamaModel } from './types';

export const WORK_DIR_NAME = 'project';
export const WORK_DIR = `/home/${WORK_DIR_NAME}`;
export const MODIFICATIONS_TAG_NAME = 'bolt_file_modifications';
export const MODEL_REGEX = /^\[Model: (.*?)\]\n\n/;
export const DEFAULT_MODEL = 'gpt-4o';
export const DEFAULT_PROVIDER = 'OpenAI';

const staticModels: ModelInfo[] = [
  // OpenAI Models (put GPT-4o first)
  { name: 'gpt-4o', label: 'GPT-4o', provider: 'OpenAI' },
  { name: 'gpt-4o-mini', label: 'GPT-4o Mini', provider: 'OpenAI' },
  { name: 'gpt-4-turbo-preview', label: 'GPT-4 Turbo', provider: 'OpenAI' },
  { name: 'gpt-3.5-turbo', label: 'GPT-3.5 Turbo', provider: 'OpenAI' },
  
  // Anthropic Models
  { name: 'claude-3-opus-20240229', label: 'Claude 3 Opus', provider: 'Anthropic' },
  { name: 'claude-3-sonnet-20240229', label: 'Claude 3 Sonnet', provider: 'Anthropic' },
  { name: 'claude-3-haiku-20240307', label: 'Claude 3 Haiku', provider: 'Anthropic' },
  
  // Groq Models
  { name: 'llama-3.1-70b-versatile', label: 'Llama 3.1 70b', provider: 'Groq' },
  { name: 'llama-3.1-8b-instant', label: 'Llama 3.1 8b', provider: 'Groq' },
  { name: 'llama-3.2-11b-vision-preview', label: 'Llama 3.2 11b', provider: 'Groq' },
  { name: 'llama-3.2-3b-preview', label: 'Llama 3.2 3b', provider: 'Groq' },
  { name: 'llama-3.2-1b-preview', label: 'Llama 3.2 1b', provider: 'Groq' },
];

export let MODEL_LIST: ModelInfo[] = [...staticModels];

// Function to get models by provider
export function getModelsByProvider(provider: string): ModelInfo[] {
  return MODEL_LIST.filter(model => model.provider === provider);
}

// Get Ollama models if available
export async function getOllamaModels(): Promise<ModelInfo[]> {
  try {
    const base_url = import.meta.env.OLLAMA_API_BASE_URL || "http://localhost:11434";
    const response = await fetch(`${base_url}/api/tags`);
    const data = await response.json() as OllamaApiResponse;
    return data.models.map((model: OllamaModel) => ({
      name: model.name,
      label: `${model.name} (${model.details.parameter_size})`,
      provider: 'Ollama',
    }));
  } catch (e) {
    return [];
  }
}

// Initialize model list
export async function initializeModelList(): Promise<void> {
  const ollamaModels = await getOllamaModels();
  MODEL_LIST = [...staticModels, ...ollamaModels];
}
