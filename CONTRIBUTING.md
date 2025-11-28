# Contributing

Contributions are welcome through GitHub pull request. This document outlines the steps to facilitate the acceptance of your contribution.

## How to Contribute

1. Fork repository, develop, and test your changes.
2. Bump the chart version and update chart documentation.
3. Submit a pull request.

To simplify testing and merging, please submit changes for only one chart per pull request.

### Technical Requirements

* Must follow [charts best practices](https://helm.sh/docs/topics/chart_best_practices/).
* Must pass CI jobs for linting and installing changed charts with the [chart-testing](https://github.com/helm/chart-testing) tool.
* Any change to a chart requires a version bump following [semver](https://semver.org/) principles. See [Immutability](#immutability) and [Versioning](#versioning) below.

Once changes have been merged, the release job will automatically run to package and release changed charts.

### Immutability

Chart releases must be immutable. Any change to a chart, including documentation updates, requires bumping the chart version.

### Versioning

Version numbers follow [semantic versioning](https://semver.org/). When making changes to a chart, update the version in `Chart.yaml` as follows:

- MAJOR version (x.0.0): Incompatible API changes
  * Breaking changes to values.yaml structure.
  * Removal of deprecated features.
  * Major Kubernetes version requirement changes.

- MINOR version (0.x.0): Added functionality in a backward compatible manner
  * New optional parameters or features.
  * New capabilities that maintain backward compatibility.

- PATCH version (0.0.x): Backward compatible bug fixes or documentation updates
  * Bug fixes that don't change the chart's functionality.
  * Documentation improvements.
  * Minor clarifications or corrections.
  
### Development Setup

Install the required tools:

```shell
# Install helm-unittest plugin
helm plugin install https://github.com/helm-unittest/helm-unittest.git

# Install helm-docs (for documentation generation)
# macOS
brew install norwoodj/tap/helm-docs
# or download from https://github.com/norwoodj/helm-docs/releases
```

### Running Tests

```shell
# Run unit tests for a specific chart
helm unittest charts/greptimedb-cluster
helm unittest charts/greptimedb-standalone

# Run all checks (docs and CRDs)
make check-docs
make check-crds
```

### Generate documentation

Documentation for charts is automatically generated from the following sources:
- Chart.yaml: Metadata and version information.
- values.yaml: Configuration options and defaults.
- README.md.gotmpl: Template for the chart's README.

To regenerate documentation after making changes:

```shell
make docs
```

### Community Requirements

This project is released with a [Contributor Covenant](https://www.contributor-covenant.org).
By participating in this project you agree to abide by its terms.
See [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md).
