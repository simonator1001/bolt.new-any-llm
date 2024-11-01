export interface ModelInfo {
  name: string;
  label: string;
  provider: string;
}

export interface OllamaModel {
  name: string;
  details: {
    parameter_size: string;
  };
}

export interface OllamaApiResponse {
  models: OllamaModel[];
} 