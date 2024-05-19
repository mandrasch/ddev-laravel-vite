# ddev-laravel-vite

Demo repository for Laravel v10 with [DDEV](https://ddev.com/), including Vite support. 

- Local URL: https://ddev-laravel-vite.ddev.site/

Tutorial: [Install Laravel with Vite support in DDEV (Docker)](https://dev.to/mandrasch/install-laravel-with-vite-support-in-ddev-docker-4lmh)

## Local setup 

```bash
ddev start
ddev composer install
ddev exec "cp .env.example .env"
ddev artisan key:generate

# open in browser, vite does not work yet
ddev launch

# install and run vite:
ddev npm install
ddev npm run dev

# reload your browser, vite should work now 🥳
```

After that, only `ddev npm run dev` is needed (after `ddev start`). 

## How was this created?

1. Installed Laravel in DDEV via [quickstart documentation](https://ddev.readthedocs.io/en/latest/users/quickstart/#laravel).

```bash
ddev config --project-type=laravel --docroot=public --php-version="8.2" --database="mysql:8.0" --nodejs-version="20"
ddev start
ddev composer create "laravel/laravel:^11"
ddev artisan key:generate

# open in browser
ddev launch
```

2. After that we need to expose the vite port of the DDEV (docker) container so that it can be reached from outside (= from our computer) while developing. The http_port does not really matter. 

Add this to your `.ddev/config.yaml`:

```yaml 
# .ddev/config.yaml
web_extra_exposed_ports:
  - name: vite
    container_port: 5173
    http_port: 5172
    https_port: 5173
```

⚠️  A `ddev restart` is needed after that.

_See [Exposing Extra Ports via ddev-router](https://ddev.readthedocs.io/en/latest/users/extend/customization-extendibility/#exposing-extra-ports-via-ddev-router) for more information. You'll need at least DDEV [v1.20.0](https://github.com/ddev/ddev/releases/tag/v1.20.0) for this, before it was done via docker-compose files ([example](https://github.com/torenware/ddev-viteserve/blob/master/docker-compose.viteserve.yaml))._

3. The [`vite.config.js`](https://github.com/mandrasch/ddev-laravel-vite/blob/main/vite.config.js) needs some modifications as well. These `.server` options were added:

```js
 server: {
        // respond to all network requests (same as '0.0.0.0')
        host: true,
        // we need a strict port to match on PHP side
        strictPort: true,
        port: 5173,
        hmr: {
            // Force the Vite client to connect via SSL
            // This will also force a "https://" URL in the public/hot file
            protocol: 'wss',
            host: `${process.env.DDEV_HOSTNAME}`
        }
    },
```

4. Then we need to follow the [Asset Bundling (Vite)](https://laravel.com/docs/10.x/vite#loading-your-scripts-and-styles) documentation and add the output to the `welcome.blade.php` template.

```blade
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Include JS and CSS via vite, see https://laravel.com/docs/10.x/vite -->
    @vite('resources/js/app.js')
</head>

<body>
    <h1>Hello, vite!</h1>
    <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.</p>
</body>
</html>
```

5. Add the CSS to to the `resources/js/app.js` file:

```js
// import css:
import '../css/app.css'

import './bootstrap';
```

6. If you now run `ddev npm run dev` vite should handle the reloading. Test with the following in `app.css

```css
p{
    color:red !important;
}
```

## Deployment / production

You can simulate the production environment like this:

1. Run `ddev npm run build`
2. Set `APP_ENV=local` to `APP_ENV=production` in `.env`

Your styles will be imported like this:

```html
<link rel="preload" as="style" href="https://ddev-laravel-vite.ddev.site/build/assets/app-3845d7e3.css" />
```

## TODOs

- [ ] Support for Gitpod and Github Codespaces? (See https://github.com/tyler36/lara10-base-demo or https://github.com/mandrasch/ddev-craftcms-vite for DDEV + Vite + Codespaces example)

## Technical background

Laravel uses a combination of PHP config files (`@vite` blade directive) in combination with their NodeJS package [laravel-vite-plugin](https://www.npmjs.com/package/laravel-vite-plugin). For local development the file `public/hot` connects these two. 

See [DDEV vite](https://my-ddev-lab.mandrasch.eu/tutorials/nodejs-tools/vite.html) for general information.

## Reset the demo

```bash
# delete without snapshot
ddev delete -O
# reset files, beware: deletes all untracked files!
git clean -fdx
```

## Further resources

- See also https://github.com/tyler36/lara10-base-demo
- https://github.com/mandrasch/ddev-laravel-breeze-vite/
- There is also a ddev-addon for vite ([ddev-viteserve](https://github.com/torenware/ddev-viteserve))
- Connect with the DDEV community on [Discord](https://discord.gg/hCZFfAMc5k)

More experiments and info about DDEV + vite: https://my-ddev-lab.mandrasch.eu/

Thanks to the DDEV maintainers and DDEV open source community! 💚
