# Contributing to Kaveh

Thank you for your interest in contributing to Kaveh! This document provides guidelines and instructions for contributing to this vSphere Terraform automation project.

## 🤝 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## 🛠️ Development Setup

### Prerequisites

- Terraform >= 1.0
- TFLint for code linting
- terraform-docs for documentation generation
- Access to a vSphere environment for testing

### Setup Instructions

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/yourusername/kaveh.git
   cd kaveh
   ```

3. Install required tools:
   ```bash
   # macOS
   brew install terraform tflint terraform-docs

   # Or check our Makefile
   make check-tools
   ```

4. Initialize the project:
   ```bash
   make init
   ```

## 📝 Contributing Guidelines

### Coding Standards

- Follow Terraform best practices and naming conventions
- Use snake_case for variables, resources, and modules
- Add descriptions to all variables and outputs
- Include comprehensive validation rules for variables
- Write clear and concise comments explaining complex logic
- Ensure all code is properly formatted (`terraform fmt`)

### Testing

Before submitting a pull request:

1. **Format your code:**
   ```bash
   make format
   ```

2. **Validate configuration:**
   ```bash
   make validate
   ```

3. **Run linting:**
   ```bash
   make lint
   ```

4. **Run all tests:**
   ```bash
   make test
   ```

### Documentation

- Update README.md if you add new features or change existing functionality
- Add examples for new features in the `examples/` directory
- Include inline comments for complex Terraform configurations
- Update variable descriptions and validation rules

### Commit Messages

Use conventional commit format:

- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Test additions or modifications
- `chore:` Maintenance tasks

Example:
```
feat: add support for Windows VM customization

- Add Windows-specific customization options
- Include timezone and workgroup configuration
- Update examples with Windows deployment scenarios
```

## 🔄 Pull Request Process

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes following the coding standards**

3. **Test your changes thoroughly**

4. **Update documentation as needed**

5. **Submit a pull request with:**
   - Clear title and description
   - Reference to any related issues
   - Screenshots or examples if applicable
   - Confirmation that tests pass

6. **Address any feedback from reviewers**

## 🐛 Bug Reports

When filing bug reports, please include:

- Terraform version
- vSphere version
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Relevant configuration snippets
- Error messages or logs

## 💡 Feature Requests

For feature requests:

- Describe the use case and benefits
- Provide examples of how it would be used
- Consider backward compatibility
- Discuss implementation approach if you have ideas

## 🔒 Security

If you discover security vulnerabilities:

- **DO NOT** create a public issue
- Email the maintainer privately
- Provide detailed information about the vulnerability
- Allow time for the issue to be addressed before disclosure

## 📋 Module Development Guidelines

When adding new modules:

1. **Structure:**
   ```
   modules/your-module/
   ├── main.tf      # Resource definitions
   ├── variables.tf # Input variables with validation
   ├── outputs.tf   # Output values
   └── README.md    # Module documentation
   ```

2. **Standards:**
   - Include comprehensive variable validation
   - Provide meaningful outputs
   - Add usage examples
   - Document all requirements and dependencies

3. **Testing:**
   - Create examples in `examples/` directory
   - Test with different configurations
   - Verify compatibility with various vSphere versions

## 🏷️ Release Process

Releases follow semantic versioning (SemVer):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

## 🤖 Automation

This project uses GitHub Actions for:

- **Continuous Integration:** Format checking, validation, and linting
- **Documentation:** Automatic README generation with terraform-docs
- **Testing:** Automated testing of configurations

## 📚 Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [vSphere Provider Documentation](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

## 🙏 Recognition

Contributors will be recognized in the README.md file. Thank you for helping make Kaveh better!

## ❓ Questions

If you have questions that aren't covered in this guide:

- Check existing issues and discussions
- Create a new discussion for general questions
- Create an issue for specific bugs or feature requests
- Reach out to the maintainers

---

**Happy contributing! ⚒️**