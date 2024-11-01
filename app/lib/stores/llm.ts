import { atom } from 'nanostores';
import { DEFAULT_MODEL, DEFAULT_PROVIDER } from '~/utils/constants';

export const selectedModel = atom(DEFAULT_MODEL);
export const selectedProvider = atom(DEFAULT_PROVIDER);

// Initialize with defaults
selectedModel.set(DEFAULT_MODEL);
selectedProvider.set(DEFAULT_PROVIDER); 