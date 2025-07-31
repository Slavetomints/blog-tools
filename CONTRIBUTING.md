# Contributing to BlogTools

First off, thanks for taking the time to contribute!
Whether you're fixing a bug, suggesting a feature, improving the docs, or writing tests, your help is appreciated.

---

## How to Contribute

### 1. Fork the Repository

Click the "Fork" button at the top right of the [GitHub repo](https://github.com/slavetomints/blog-tools), then clone your fork:

```sh
git clone https://github.com/YOUR-USERNAME/blog-tools.git
cd blog-tools
```

### 2. Set Up Your Environment

We use Ruby. Make sure you have a recent version installed via rbenv, rvm, or system Ruby (we recommend rbenv).

```sh
bundle install
```

To run the CLI locally:

```sh
bin/blog-tools
```

### 3. Create a Branch

Name your branch based on what you're doing:

```sh
git checkout -b fix-missing-command
```

### 4. Make Your Changes

- Follow the existing coding style (run `rubocop` to check).
- Add or update tests where applicable.
- Keep commits focused and clear.

### 5. Test Your Changes

Make sure all tests pass before submitting:

```sh
rake check
```

### 6. Submit a Pull Request

Push your branch to your fork and open a pull request against main. Include:

- A short, descriptive title
- A summary of what and why
- A mention of any related issues (e.g., Closes #12)

## Suggestions or Questions

Open an issue to start a discussion! We're happy to help and open to feedback.

## Code Style & Guidelines

- Stick to idiomatic Ruby
- Use 2-space indentation
- Follow existing naming patterns
- Lint with `rubocop` before committing

## License

By contributing, you agree that your contributions will be licensed under the same license as the project: MIT.

---
