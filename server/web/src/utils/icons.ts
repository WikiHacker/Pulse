/**
 * Load OS icons using Iconify API
 */
export async function loadOSIcons(): Promise<void> {
  const iconElements = document.querySelectorAll('.os-icon');
  for (const el of iconElements) {
    const iconName = (el as HTMLElement).dataset.icon;
    if (!iconName) continue;
    
    try {
      const response = await fetch(`https://api.iconify.design/${iconName}.svg?height=10`);
      if (response.ok) {
        const svg = await response.text();
        el.innerHTML = svg;
        const svgEl = el.querySelector('svg');
        if (svgEl) {
          svgEl.setAttribute('class', 'block leading-none');
          svgEl.style.margin = '0';
          svgEl.style.padding = '0';
          svgEl.style.display = 'block';
        }
      }
    } catch (e) {
      // Icon load failed silently
    }
  }
}
