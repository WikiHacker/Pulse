/**
 * Auto-detect API base URL from current hostname
 */
export function getApiBase(root: HTMLElement | null): string {
  // Priority 1: Use data attribute if provided (from Astro props or env var)
  if (root?.dataset.apiBase && root.dataset.apiBase.trim() !== '') {
    return root.dataset.apiBase.trim();
  }
  // Priority 2: Use current origin (works with nginx reverse proxy)
  // This allows the frontend to work on any port when served by nginx
  return window.location.origin;
}

/**
 * Fetch system metrics from backend
 */
export async function fetchSystemMetrics(apiBase: string): Promise<any[]> {
  const res = await fetch(`${apiBase}/api/metrics`, { cache: 'no-store' });
  
  if (!res.ok) {
    throw new Error(`HTTP ${res.status}`);
  }
  
  const data = await res.json();
  
  if (Array.isArray(data)) {
    return data;
  } else if (data === null) {
    return [];
  } else {
    return [];
  }
}
