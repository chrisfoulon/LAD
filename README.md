# LAD — LLM-Assisted Development Prompt Kit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

LAD lets GitHub Copilot + Claude implement complex Python features *iteratively* and *safely*—from context gathering to squash-merged PR—with zero extra infrastructure.

## Features

✅ **Test-driven development** with atomic task breakdowns  
✅ **Component-aware testing** (integration for APIs, unit for business logic)
✅ **Multi-level documentation** with collapsible sections  
✅ **NumPy-style docstrings** enforced throughout  
✅ **GitHub Flow** with automated PR creation/cleanup  
✅ **Agent autonomy** with diff approval workflow  

## Quick Start

```bash
# Clone your project
git clone https://github.com/yourorg/your-project.git
cd your-project

# Import LAD kit once on main (copy-only, no Git dependency)
git clone --depth 1 https://github.com/chrisfoulon/LAD tmp \
  && rm -rf tmp/.git && mv tmp .lad \
  && git add .lad && git commit -m "feat: add LAD framework"

# Start your first feature
git checkout -b feat/my-feature
code .lad/prompts/00_feature_kickoff.md   # paste into Copilot Chat
```

## Documentation

📖 **[Full workflow guide](LAD_RECIPE.md)** — Complete step-by-step instructions  
🎯 **[Prompt templates](prompts/)** — Ready-to-paste prompts for each step  

## Requirements

- VS Code with GitHub Copilot + Claude Agent extensions
- Python 3.11+
- `gh` CLI for PR management (optional)

## Code Quality Setup

LAD uses several tools to maintain code quality. Install them once per project:

```bash
pip install flake8 pytest coverage radon flake8-radon black
```

The LAD workflow will guide you through creating `.flake8` and `.coveragerc` configuration files during the kickoff process.

## License

This project is licensed under the [MIT License](LICENSE.md).

## Contributing

Improvements welcome! See [LAD_RECIPE.md](LAD_RECIPE.md) for the full framework details.

