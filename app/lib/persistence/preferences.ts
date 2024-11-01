import { DEFAULT_MODEL, DEFAULT_PROVIDER } from '~/utils/constants';

export function getInitialPreferences() {
  return {
    selectedModel: DEFAULT_MODEL,
    selectedProvider: DEFAULT_PROVIDER,
  };
} 