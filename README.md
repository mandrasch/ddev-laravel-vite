# ddev-laravel-vite

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/mandrasch/ddev-laravel-vite/)

Demo repository for Laravel v11 with [DDEV](https://ddev.com/), including Vite support. 

Based on the tutorial [Install Laravel with Vite support in DDEV (Docker)](https://dev.to/mandrasch/install-laravel-with-vite-support-in-ddev-docker-4lmh). See https://ddev.com/blog/working-with-vite-in-ddev/ as well for all information.

You can run this 

1. on [your local laptop](#1-local-setup)
1. via [Gitpod in your browser](#2-gitpod)
1. via [Codespaces (experimental)](#3-codespaces-experimental)

## 1. Local setup 

Install [DDEV](https://ddev.com/get-started/) and run the following commands:

```bash
git clone https://github.com/mandrasch/ddev-laravel-vite.git
# or git clone git@github.com:mandrasch/ddev-laravel-vite.git

cd ddev-laravel-vite/

# automatically creates .env with correct db settings
ddev start

# install dependencies
ddev composer install && ddev npm install

# create key for .env
ddev artisan key:generate

# create db tables
ddev artisan migrate

# Open your website in browser, ...
ddev launch

# start the local dev server (Vite), ...
ddev npm run dev

# ... and hit reload in browser. Vite should work now 🥳
```

After this first time setup, only `ddev npm run dev` is needed (after `ddev start`). 

Your site is accessible via https://ddev-laravel-vite.ddev.site.

You could also import a database dump via `ddev import-db --file=dump.sql.gz` or use [`ddev pull`](https://ddev.readthedocs.io/en/stable/users/providers/) to setup a project. Use `ddev sequelace` to view your database.

## 2. Gitpod

Just hit the button, wait for the initial setup and start developing:

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/mandrasch/ddev-laravel-vite/)

## 3. Codespaces (experimental)

⚠️ Disclaimer - May 2024: Codespaces is currently a bit buggy on startups, see https://github.com/devcontainers/features/issues/977.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/mandrasch/ddev-laravel-vite)

1. Click the button
1. Wait for `postCreateCommand.sh` to be finished
1. Switch Vite port to public in ports tab (can't be automated currently)
1. Run `ddev npm run dev`
1. Open site (web http) via ports tab (or use `ddev launch` in future (currently small bug to be fixed)).

The port switch can take a minute. Just wait if it doesn't work instantly.

Access control panel via `/admin` (or use in future `ddev launch /admin`, when small bug is fixed in ddev).

Login via user `admin` and password `newPassword` .

### Troubleshooting

See creation log via 'CMD + P > View creation log' if errors occur. Unfortunately there is no general error notification when this fails. But if there is only one port in the ports tab installation did not succeed. Sometimes only a full rebuild solve the problems, use:

- `SHIFT + CMD + P > Codespaces: Full rebuild` 

Containers and db will be deleted.

## How was this created?

Tutorial: [Install Laravel with Vite support in DDEV (Docker)](https://dev.to/mandrasch/install-laravel-with-vite-support-in-ddev-docker-4lmh). 

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
import laravel from 'laravel-vite-plugin';

const port = 5173;
const origin = `${process.env.DDEV_PRIMARY_URL}:${port}`;

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
        // this will also be used for the public/hot file (devserver URL)
        origin: origin
    }
});

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

## Reset the demo

```bash
# delete without snapshot
ddev delete -O
# reset files, beware: deletes all untracked files!
git clean -fdx
# reset files, but not .ddev
git clean -fdx -e .ddev/
```

## Acknowledgements

Thanks to the DDEV maintainers and DDEV open source community, especially [Ofer Shaal](https://github.com/shaal) for providing DrupalPod, [Randy Fay](https://github.com/rfay) and [tyler36](https://github.com/tyler36) for suggestions and feedback! 💚

## Further resources

- Other Laravel demos: https://github.com/mandrasch?tab=repositories&q=ddev-laravel&type=&language=&sort=
- https://github.com/tyler36/lara10-base-demo

More experiments and notes about DDEV + vite: https://my-ddev-lab.mandrasch.eu/

Connect with the DDEV community on [Discord](https://discord.gg/hCZFfAMc5k)
