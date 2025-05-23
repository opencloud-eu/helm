# Contributing to OpenCloud Helm Charts

Thank you for your interest in contributing to the OpenCloud Helm Charts repository!

## Repository Structure

This repository follows a community-driven approach with a simple role model:

- **Contributors**: Anyone who submits PRs
- **Reviewers**: Experienced contributors who can review and approve PRs
- **Maintainers**: Active reviewers who can additionally merge PRs and manage releases

You can find the current list of maintainers and reviewers in the [MAINTAINERS.md](./MAINTAINERS.md) file.

## Contribution Workflow

### 1. Fork and Clone

```bash
git clone https://github.com/YOUR-USERNAME/helm.git
cd helm
git remote add upstream https://github.com/opencloud-eu/helm.git
```

### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
```

### 3. Make Changes and Test

When making changes, please ensure you:
- Follow Helm best practices
- Include proper documentation
- Test your changes with `helm lint` and installation tests

### 4. Submit a Pull Request

- Create a PR from your fork to the main repository
- Ensure your PR has a clear description of the changes
- At least one reviewer must approve before a maintainer can merge

## Release Process

### Creating a Release

Only maintainers can create releases. The process is:

1. **Update versions**: Update the version in all Chart.yaml files
2. **Update documentation**: Add release notes to CHANGELOG.md (if exists)
3. **Create PR**: Submit a PR with the version changes
4. **Tag after merge**: After the PR is merged, create and push a tag:
   ```bash
   git tag -a v0.x.x -m "Release v0.x.x"
   git push origin v0.x.x
   ```

### Version Guidelines (0.x.x phase)

During the initial development phase (0.x.x), we follow these conventions:
- `0.x.0` - Breaking changes (incompatible API/values changes)
- `0.x.y` - New features (backwards compatible)
- `0.x.y-z` - Bug fixes only

Note: As per [SemVer 2.0](https://semver.org/spec/v2.0.0.html#spec-item-4), the 0.x.x range indicates the API is not stable and breaking changes may occur.

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).

## Becoming a Maintainer or Reviewer

Contributors who make multiple high-quality PRs may be invited to become Reviewers.
Reviewers who are consistently active and provide valuable reviews may be invited to become Maintainers.

If you're interested in becoming a maintainer or reviewer, please continue contributing and engaging with the project.