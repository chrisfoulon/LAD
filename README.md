# LAD — LLM-Assisted Development Prompt Kit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

LAD lets GitHub Copilot + Claude implement complex Python features *iteratively* and *safely*—from context gathering to squash-merged PR—with zero extra infrastructure.

## Features

✅ **Test-driven development** with atomic task breakdowns  
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

## License

This project is licensed under the [MIT License](LICENSE.md).

## Contributing

Improvements welcome! See [LAD_RECIPE.md](LAD_RECIPE.md) for the full framework details.

