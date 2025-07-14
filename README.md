# LAD — LLM-Assisted Development Prompt Kit

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

LAD lets GitHub Copilot Chat + Claude Code implement complex Python features *iteratively* and *safely*—from context gathering to squash-merged PR—with zero extra infrastructure.

## Features

✅ **Test-driven development** with atomic task breakdowns  
✅ **Component-aware testing** (integration for APIs, unit for business logic)
✅ **Multi-level documentation** with collapsible sections  
✅ **NumPy-style docstrings** enforced throughout  
✅ **GitHub Flow** with automated PR creation/cleanup  
✅ **Agent autonomy** with diff approval workflow  

## Choose Your Workflow

LAD supports two optimized workflows:

### 🚀 Claude Code (Recommended for 2025)
**Autonomous 3-phase workflow with 75% less intervention**
```bash
# Import LAD kit
git clone --depth 1 https://github.com/chrisfoulon/LAD tmp \
  && rm -rf tmp/.git && mv tmp .lad \
  && git add .lad && git commit -m "feat: add LAD framework"

# Start feature with autonomous workflow
git checkout -b feat/my-feature
# Paste .lad/claude_prompts/01_autonomous_context_planning.md into Claude Code
```

### 🛠️ GitHub Copilot Chat (VSCode)
**Step-by-step 8-prompt workflow for VSCode users**
```bash
# Same LAD import as above
git checkout -b feat/my-feature
code .lad/copilot_prompts/00_feature_kickoff.md   # paste into Copilot Chat
```

## Documentation

📖 **[Full workflow guide](LAD_RECIPE.md)** — Complete step-by-step instructions  
🚀 **[Claude Code prompts](claude_prompts/)** — 3-phase autonomous workflow  
🛠️ **[Copilot Chat prompts](copilot_prompts/)** — 8-step guided workflow  

## Requirements

### For Claude Code Workflow
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- Python 3.11+
- Git repository

### For Copilot Chat Workflow  
- VS Code with GitHub Copilot + Claude Agent extensions
- Python 3.11+
- `gh` CLI for PR management (optional)

## Code Quality Setup

LAD uses several tools to maintain code quality. Install them once per project:

```bash
pip install flake8 pytest coverage radon flake8-radon black
```

Both LAD workflows will guide you through creating `.flake8` and `.coveragerc` configuration files during the kickoff process.

## Claude Code vs Copilot Chat

| Feature | Claude Code | Copilot Chat |
|---------|-------------|--------------|
| **Intervention Points** | 2 decisions | 8 manual steps |
| **Context Gathering** | Autonomous codebase exploration | Manual file opening |
| **Progress Tracking** | TodoWrite integration | Manual markdown files |
| **Testing** | Autonomous test execution | Manual command running |
| **Quality Gates** | Integrated validation | Manual quality checks |
| **Setup Time** | ~5 minutes | ~10 minutes |
| **Development Speed** | 3-5x faster | Baseline |

## License

This project is licensed under the [MIT License](LICENSE.md).

## Contributing

Improvements welcome! See [LAD_RECIPE.md](LAD_RECIPE.md) for the full framework details.

