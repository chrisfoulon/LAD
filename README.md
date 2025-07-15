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
✅ **Intelligent model selection** for optimal cost and performance  
✅ **Multi-model validation** for complex features  
✅ **Cost optimization** with 30-50% savings through appropriate model routing  

## Choose Your Workflow

LAD supports two optimized workflows:

### 🚀 Claude Code (Recommended for 2025)
**Autonomous multi-phase workflow with 75% less intervention + intelligent model optimization**
```bash
# Import LAD kit
git clone --depth 1 https://github.com/chrisfoulon/LAD tmp \
  && rm -rf tmp/.git && mv tmp .lad \
  && git add .lad && git commit -m "feat: add LAD framework"

# Start feature with autonomous workflow
git checkout -b feat/my-feature
# Tell Claude Code: "Use LAD framework to implement [feature description]"
# Claude will automatically read and execute the appropriate .lad prompt files
```

### 🛠️ GitHub Copilot Chat (VSCode)
**Step-by-step 8-prompt workflow for VSCode users**
```bash
# Same LAD import as above
git checkout -b feat/my-feature
code .lad/copilot_prompts/00_feature_kickoff.md   # paste into Copilot Chat
```

## Model Optimization

### Intelligent Model Selection
LAD automatically selects the most appropriate Claude model based on task complexity:

- **Simple tasks** (Haiku 3.5): Documentation, typos, basic operations → 15x cost reduction
- **Medium tasks** (Sonnet 4): Feature implementation, testing, refactoring → 5x cost reduction  
- **Complex tasks** (Opus 4): Architecture, security, performance optimization → Premium performance
- **Extended tasks** (Sonnet 3.7/4): Multi-step analysis, complex debugging → Extended thinking mode

### Cost Optimization Benefits
- **30-50% cost reduction** through intelligent model routing
- **Maintained quality standards** across all complexity levels
- **Performance optimization** with faster responses for simple tasks
- **Automatic escalation** for complex issues requiring higher-capability models

### Multi-Model Validation
- **Cross-validation** for complex or critical features
- **Independent review** by different models to catch blind spots
- **Quality assurance** through diverse model perspectives
- **Risk mitigation** for high-stakes implementations

## Documentation

📖 **[Full workflow guide](LAD_RECIPE.md)** — Complete step-by-step instructions  
🚀 **[Claude Code prompts](claude_prompts/)** — 3-phase autonomous workflow with model optimization  
🛠️ **[Copilot Chat prompts](copilot_prompts/)** — 8-step guided workflow  
💡 **[Model selection guide](claude_prompts/model_selection_guide.md)** — Model optimization reference  

## Requirements

### For Claude Code Workflow
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- Access to multiple Claude models (Haiku 3.5, Sonnet 4, Opus 4, Sonnet 3.7)
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
| **Model Optimization** | Intelligent model selection | Single model approach |
| **Cost Efficiency** | 30-50% cost reduction | Standard costs |
| **Setup Time** | ~5 minutes | ~10 minutes |
| **Development Speed** | 3-5x faster | Baseline |

## Model Optimization Workflow

### Phase 0: Feature Kickoff
- Environment setup and quality standards
- Configuration file creation (.flake8, .coveragerc)
- Baseline metrics establishment
- Development environment validation

### Phase 1: Context Planning with Model Assessment
- Autonomous codebase exploration
- Task complexity evaluation
- Intelligent model selection
- Cost/performance optimization

### Phase 1b: Plan Review & Validation (Optional)
- Independent plan review by different model
- Quality assurance through diverse perspectives
- Risk mitigation for critical implementations

### Phase 1c: ChatGPT Review (Optional)
- External validation by ChatGPT
- Structured review process
- Independent perspective on plan quality
- Risk and optimization identification

### Phase 1d: Review Integration
- Synthesis of multi-model feedback
- Conflict resolution between reviews
- User-guided decision making
- Plan optimization based on insights

### Phase 2: Implementation with Model Routing (Resumable)
- TDD loop with appropriate model selection
- Model escalation for complex issues
- Performance tracking and optimization
- Cross-session resumability

### Phase 3: Finalization with Optimization Analysis
- Comprehensive quality validation
- Model performance assessment
- Cost efficiency analysis
- Optimization recommendations

## License

This project is licensed under the [MIT License](LICENSE.md).

## Contributing

Improvements welcome! See [LAD_RECIPE.md](LAD_RECIPE.md) for the full framework details.
