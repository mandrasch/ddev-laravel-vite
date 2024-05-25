import { defineConfig, loadConfigFromFile } from 'vite';
import laravel from 'laravel-vite-plugin';

// defaults for local DDEV
let port = 5173;
let origin = `${process.env.DDEV_PRIMARY_URL}:${port}`;

// Gitpod support
// env var GITPOD_WORKSPACE_URL needs to be passed through to ddev
// via 'web_environment:' config, see .ddev/config.yaml
if (Object.prototype.hasOwnProperty.call(process.env, 'GITPOD_WORKSPACE_URL')) {
    origin = `${process.env.GITPOD_WORKSPACE_URL}`;
    origin = origin.replace('https://', 'https://5173-');
    console.log(`Gitpod detected, set origin to ${origin}`);
}

// Codespaces support
// env var GITPOD_WORKSPACE_URL needs to be passed through to ddev, see .ddev/config.yaml
// You need to switch the port manually to public on codespaces after launching
if (Object.prototype.hasOwnProperty.call(process.env, 'CODESPACES')) {
    origin = `https://${process.env.CODESPACE_NAME}-${port}.${process.env.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}`;
    console.log('Codespaces environment detected, setting config to ', {port,origin});
    console.log("Please check that this can be opened via browser after you run 'ddev npm run dev':");
    console.log(origin + '/src/js/app.js');
    console.log('If it can\'t be opened, please switch the Vite port to public in the ports tab.');
    /* console.log({
        'CODESPACES' : process.env?.CODESPACES,
        'CODESPACE_NAME' : process.env?.CODESPACE_NAME,
        'GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN': process.env?.GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN
    });*/
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
