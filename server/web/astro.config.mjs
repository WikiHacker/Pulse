import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import icon from 'astro-icon';

export default defineConfig({
	integrations: [tailwind(), icon()],
	server: {
		host: true, // 监听所有网络接口
		port: 4321,
	},
	vite: {
		optimizeDeps: {
			// 强制重新优化依赖
			force: true,
		},
		server: {
			hmr: {
				// 允许通过 IP 访问时的 HMR
				clientPort: 4321,
			},
		},
	},
});

