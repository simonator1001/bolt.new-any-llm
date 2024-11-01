import type { LoaderFunction } from '@remix-run/cloudflare';

export const loader: LoaderFunction = () => {
  return new Response(null, {
    status: 404,
  });
}; 