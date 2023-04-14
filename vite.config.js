import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
    server: {
        // respond to all network requests (same as '0.0.0.0')
        host: true,
        // we need a strict port to match on PHP side
        strictPort: true,
        port: 5173,
        hmr: {
            // TODO: Is this the best way to achieve that? 🤔
            // Force the Vite client to connect via SSL
            // This will also force a "https://" URL in the hot file
            protocol: 'wss',
            // The host where the Vite dev server can be accessed
            // This will also force this host to be written to the hot file
            host: 'ddev-laravel-vite.ddev.site', // TODO: How can we get it automatically?
        }
    },

});
