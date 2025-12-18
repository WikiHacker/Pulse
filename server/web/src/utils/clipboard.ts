/**
 * Copy text to clipboard with fallback support
 */
export async function copyToClipboard(text: string): Promise<boolean> {
  try {
    await navigator.clipboard.writeText(text);
    return true;
  } catch (err) {
    // Fallback for older browsers
    try {
      const textArea = document.createElement('textarea');
      textArea.value = text;
      textArea.style.position = 'fixed';
      textArea.style.opacity = '0';
      document.body.appendChild(textArea);
      textArea.select();
      document.execCommand('copy');
      document.body.removeChild(textArea);
      return true;
    } catch (fallbackErr) {
      return false;
    }
  }
}

/**
 * Setup copy button event listeners using event delegation
 */
export function setupCopyButtons(container: HTMLElement): void {
  if (!container || container.dataset.copySetup) return;
  
  container.addEventListener('click', async (e) => {
    const copyBtn = (e.target as HTMLElement).closest('.copy-btn') as HTMLButtonElement;
    if (!copyBtn) return;
    
    e.stopPropagation(); // Prevent row click event
    const systemName = copyBtn.dataset.systemName;
    if (systemName) {
      const success = await copyToClipboard(systemName);
      if (success) {
        // Show check icon feedback (keep color consistent)
        const copyIcon = copyBtn.querySelector('.copy-icon') as HTMLElement;
        const checkIcon = copyBtn.querySelector('.check-icon') as HTMLElement;
        const originalTitle = copyBtn.title;
        
        if (copyIcon && checkIcon) {
          // Switch to check icon
          copyIcon.style.display = 'none';
          checkIcon.style.display = 'block';
          copyBtn.title = 'Copied!';
          
          // Restore after 1 second
          setTimeout(() => {
            copyIcon.style.display = 'block';
            checkIcon.style.display = 'none';
            copyBtn.title = originalTitle;
          }, 1000);
        }
      }
    }
  });
  
  container.dataset.copySetup = 'true';
}
