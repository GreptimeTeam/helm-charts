# Contributing

Contributions are welcome through GitHub pull request. This document outlines the steps to facilitate the acceptance of your contribution.

## How to Contribute

1. Fork repository, develop, and test your changes.
2. Bump the chart version and update chart documentation.
3. Submit a pull request.

In order to make testing and merging of PR easier, please submit modifications to one chart in a separate pull request.

### Technical Requirements

* Must follow [charts best practices](https://helm.sh/docs/topics/chart_best_practices/).
* Must pass CI jobs for linting and installing changed charts with the [chart-testing](https://github.com/helm/chart-testing) tool.
* Any change to a chart requires a version bump following [semver](https://semver.org/) principles. See [Immutability](#immutability) and [Versioning](#versioning) below.

Once changes have been merged, the release job will automatically run to package and release changed charts.

### Immutability

Chart releases must be immutable. Any change to a chart, including documentation updates, requires bumping the chart version.

### Versioning

The PATCH version in the `Chart.yaml` should be bumped for any changes to the chart.

### Generate documentation

The documentation of each chart can be re-generated with the following command:

```shell
make docs
```

### Community Requirements

This project is released with a [Contributor Covenant](https://www.contributor-covenant.org).
By participating in this project you agree to abide by its terms.
See [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md).
