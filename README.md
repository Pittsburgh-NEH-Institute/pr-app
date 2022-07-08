# pr-app

[![License][license-img]][license-url]
[![GitHub release][release-img]][release-url]
![exist-db CI](https://github.com/Pittsburgh-NEH-Institute/pr-app/workflows/exist-db%20CI/badge.svg)

<img src="icon.png" align="left" width="25%"/>

a practice application designed with users in mind

## Requirements

*   [exist-db](http://exist-db.org/exist/apps/homepage/index.html) version: `6.0.1` or greater

*   [ant](http://ant.apache.org) version: `1.10.7` \(for building from source\)

*   [node](http://nodejs.org) version: `12.x` \(for building from source\)
    

## Installation

1.  Download  the `pr-app-1.0.0.xar` file from GitHub [releases](https://github.com/gabikeane/pr-app/releases) page. (**2022-07-05: No releases are available yet; use the “building from source” method, below.**)

2.  Open the [dashboard](http://localhost:8080/exist/apps/dashboard/index.html) of your eXist-db instance and click on `package manager`.

    1.  Click on the `add package` symbol in the upper left corner and select the `.xar` file you just downloaded.

3.  You have successfully installed pr-app into exist.

### Building from source

1.  Download, fork or clone this GitHub repository
2.  There are two default build targets in `build.xml`:
    *   `dev` including *all* files from the source folder including those with potentially sensitive information.
  
    *   `deploy` is the official release. It excludes files necessary for development but that have no effect upon deployment.
  
3.  Calling `ant`in your CLI will build both files:
  
```bash
cd pr-app
ant
```

   1. to only build a specific target call either `dev` or `deploy` like this:
   ```bash   
   ant dev
   ```   

If you see `BUILD SUCCESSFUL` ant has generated a `pr-app-1.0.0.xar` file in the `build/` folder. To install it, follow the instructions [above](#installation).



## Running Tests

To run tests locally your app needs to be installed in a running exist-db instance at the default port `8080` and with the default dba user `admin` with the default empty password.

A quick way to set this up for docker users is to simply issue:

```bash
docker run -dit -p 8080:8080 existdb/existdb:release
```

After you finished installing the application, you can run the full testsuite locally.

### Unit-tests

This app uses [mochajs](https://mochajs.org) as a test-runner. To run both xquery and javascript unit-tests type:

```bash
npm test
```

### Integration-tests

This app uses [cypress](https://www.cypress.io) for integration tests, just type:

```bash
npm run cypress
```

Alternatively, use npx:

```bash
npx cypress open
```
## Conventions
All names (variables, functions, elements, attributes) must use kebab-case. The following are regarded as single words:
- datatype
- filename


## Contributing

You can take a look at the [Contribution guidelines for this project](.github/CONTRIBUTING.md)

## License

MIT © [gab_keane](http://www.obdurodon.org)

[license-img]: https://img.shields.io/badge/license-MIT-blue.svg
[license-url]: https://opensource.org/licenses/MIT
[release-img]: https://img.shields.io/badge/release-1.0.0-green.svg
[release-url]: https://github.com/gabikeane/pr-app/releases/latest
