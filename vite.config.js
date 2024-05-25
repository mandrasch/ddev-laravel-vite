import { defineConfig, loadConfigFromFile } from 'vite';
import laravel from 'laravel-vite-plugin';

let port = 5173;
let origin = `${process.env.DDEV_PRIMARY_URL}:${port}`;

// Gitpod support
// env var GITPOD_WORKSPACE_URL needs to be passed through to ddev
// via 'web_environment:' config, see .ddev/config.yaml
if(process.env.GITPOD_WORKSPACE_URL){
    origin = `${process.env.GITPOD_WORKSPACE_URL}`;
    origin = origin.replace('https://', 'https://5173-');
    console.log(`Gitpod detected, set origin to ${origin}`);
}

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
    server: {
        // respond to all network requests
        host: '0.0.0.0',
        port: port,
        strictPort: true,
        // Defines the origin of the generated asset URLs during development,
        // this will also be used for the public/hot file (Vite devserver URL)
        origin: origin
    }
});