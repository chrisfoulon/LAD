# LLM‑Assisted‑Development (LAD) Framework

> **Goal**: Provide repeatable workflows for implementing complex Python features iteratively and safely.
>
> **Two Optimized Approaches:**
> 
> ## 🚀 Claude Code Workflow (Recommended for 2025)
> **3-phase autonomous workflow with 75% less intervention**
> 1. **Autonomous Context & Planning** — Dynamic codebase exploration + TDD planning
> 2. **Iterative Implementation** — TDD loop with continuous quality monitoring  
> 3. **Quality & Finalization** — Self-review + comprehensive validation
>
> ## 🛠️ GitHub Copilot Chat Workflow (VSCode)
> **8-step guided workflow for traditional development**
> 1. **Understand** a target slice of a large Python code‑base.
> 2. **Plan** a feature via test‑driven, step‑wise decomposition.
> 3. **Review** that plan (Claude & ChatGPT Plus).
> 4. **Implement** each sub‑task in tiny, self‑documenting commits while keeping tests green **and updating docs**.
> 5. **Merge & clean up** using a lightweight GitHub Flow.
>
> **Both approaches** deliver the same quality outcomes with different interaction models.

---

## 1 Repository Skeleton

```
├── README.md                                   # dual-workflow documentation
├── LAD_RECIPE.md                               # this file – complete guide
├── CLAUDE.md                                   # Claude Code persistent context
├── claude_prompts/                             # 🚀 Claude Code workflow
│   ├── 01_autonomous_context_planning.md
│   ├── 02_iterative_implementation.md
│   └── 03_quality_finalization.md
├── copilot_prompts/                            # 🛠️ Copilot Chat workflow  
│   ├── 00_feature_kickoff.md
│   ├── 01_context_gathering.md
│   ├── 02_plan_feature.md
│   ├── 03_review_plan.md
│   ├── 03b_integrate_review.md
│   ├── 03_chatgpt_review.md
│   ├── 04_implement_next_task.md
│   ├── 04b_regression_recovery.md
│   ├── 05_code_review_package.md
│   └── 06_self_review_with_chatgpt.md
└── .vscode/                                    # optional for Copilot workflow
    ├── settings.json               
    └── extensions.json
```

Import the complete `.lad/` directory into any target project once on main.

* Target Python 3.11.
* Commit messages follow Conventional Commits.
* All generated docs follow the *plain summary + nested `<details>`* convention.

---

## 2 Claude Code Workflow (3-Phase Autonomous)

### 2.1 Quick Setup
1. **Install Claude Code**: Follow [Claude Code installation guide](https://docs.anthropic.com/en/docs/claude-code)
2. **Import LAD framework**:
   ```bash
   git clone --depth 1 https://github.com/chrisfoulon/LAD tmp \
     && rm -rf tmp/.git && mv tmp .lad \
     && git add .lad && git commit -m "feat: add LAD framework"
   ```
3. **Create feature branch**: `git checkout -b feat/<slug>`

### 2.2 Three-Phase Execution

| Phase | Prompt | Duration | Capabilities |
|-------|--------|----------|--------------|
| **1. Context & Planning** | `claude_prompts/01_autonomous_context_planning.md` | ~10-15 min | Autonomous codebase exploration, TodoWrite task breakdown, sub-plan evaluation |
| **2. Implementation** | `claude_prompts/02_iterative_implementation.md` | ~30-120 min | TDD loop, continuous testing, quality gates, progress tracking |
| **3. Finalization** | `claude_prompts/03_quality_finalization.md` | ~5-10 min | Self-review, documentation, conventional commits |

**Key Benefits**: 
- 🎯 **75% less intervention** — 2 decision points vs 8 manual steps
- ⚡ **3-5x faster development** — Autonomous execution with real-time feedback
- 🔄 **Continuous quality** — Integrated testing and regression prevention  
- 📊 **Progress visibility** — TodoWrite integration for status tracking

### 2.3 Claude Code Workflow Features

**Autonomous Context Gathering**: 
- Uses Task/Glob/Grep tools for codebase exploration
- No need to manually open files or navigate directories
- Dynamic context based on feature requirements

**Integrated Quality Assurance**:
- Autonomous test execution with Bash tool
- Real-time regression testing
- Automated quality gates (flake8, coverage)

**Smart Progress Management**:
- TodoWrite for cross-session state persistence
- Automatic sub-plan splitting for complex features
- Context evolution for multi-phase implementations

---

## 3 Copilot Chat Workflow (8-Step Guided)

### 3.1 Quick‑Setup Checklist

1. Enable **Copilot Chat + Agent Mode** in VS Code.
2. **Import LAD kit once on main** (one-time setup):
   ```bash
   git clone --depth 1 https://github.com/chrisfoulon/LAD tmp \
     && rm -rf tmp/.git \
     && mv tmp .lad \
     && git add .lad && git commit -m "feat: add LAD framework"
   ```   * **Initialize coverage**: if `.coveragerc` is missing, scaffold it as above (branch=True, dynamic_context=test_function, omit `.lad/*`, show_missing=True, HTML dir `coverage_html`), then **manually** run:
     ```bash
     coverage run -m pytest [test_files] -q && coverage html
     ```
     in your external shell. Confirm back to Copilot with **coverage complete** before any deletion checks.
3. Install helper extensions (Python, Test Explorer, Coverage Gutters, Flake8).
4. Create **feature branch**:
   ```bash
   git checkout -b feat/<slug>
   ```
5. Open relevant files so Copilot sees context.

---

### 3.2 End‑to‑End Workflow

| # | Action                                                             | Prompt                                                 |
| - | ------------------------------------------------------------------ | ------------------------------------------------------ |
| 0 | **Kick‑off** · import kit & gather clarifications                  | `copilot_prompts/00_feature_kickoff.md`                                |
| 1 | Gather context → multi‑level docs                                  | `copilot_prompts/01_context_gathering.md`                              |
| 2 | Draft test‑driven plan                                             | `copilot_prompts/02_plan_feature.md`                                   |
| 3 | Claude plan review                                                 | `copilot_prompts/03_review_plan.md`                                    |
| 3b| Integrate Copilot & ChatGPT reviews + evaluate plan splitting      | `copilot_prompts/03b_integrate_review.md`                              |
| 3c| ChatGPT cross-validation                                           | `copilot_prompts/03_chatgpt_review.md`                                 |
| 4 | Implement **next** task → commit & push (supports sub-plans)       | `copilot_prompts/04_implement_next_task.md`                            |
| 4b| **Regression Recovery** (when tests break during implementation)   | `copilot_prompts/04b_regression_recovery.md`                           |
| 5 | ChatGPT self-review (optional)                                     | `copilot_prompts/06_self_review_with_chatgpt.md`                       |
| 6 | Compile review bundle → ChatGPT                                    | `copilot_prompts/05_code_review_package.md`                            |
| 7 | **Open PR** via `gh pr create`                                     | (shell)                                                |
| 8 | **Squash‑merge & delete branch** via `gh pr merge --delete-branch` | (shell)                                                |

### 3.3 Plan Splitting for Complex Features

**Both workflows support automatic plan splitting** when complexity becomes unmanageable (>6 tasks, >25-30 sub-tasks, mixed domains):

**Splitting Benefits:**
- **Foundation-First**: Core models and infrastructure implemented first
- **Domain Separation**: Security, performance, and API concerns handled separately  
- **Context Inheritance**: Each sub-plan builds on previous implementations
- **Manageable Scope**: Each sub-plan stays ≤6 tasks, ≤25 sub-tasks

**Sub-Plan Structure:**
- `plan_0a_foundation.md` - Core models, job management, infrastructure
- `plan_0b_{{domain}}.md` - Business logic, pipeline integration
- `plan_0c_interface.md` - API endpoints, external interfaces  
- `plan_0d_security.md` - Security, performance, compatibility

**Context Evolution:** As each sub-plan completes, context files for subsequent sub-plans are updated with new APIs, interfaces, and integration points, ensuring later phases have complete system visibility.

### 3.3c Testing Strategy Framework

**LAD uses component-appropriate testing strategies** to ensure both comprehensive coverage and efficient development:

**API Endpoints & Web Services:**
- **Integration Testing**: Import and test the real FastAPI/Django/Flask app
- **Mock External Dependencies**: Only databases, external APIs, file systems
- **Test Framework Behavior**: HTTP routing, validation, serialization, error handling
- **Why**: APIs are integration points - the framework behavior is part of what you're building

**Business Logic & Algorithms:**
- **Unit Testing**: Mock all dependencies, test in complete isolation
- **Focus**: Edge cases, error conditions, algorithmic correctness
- **Benefits**: Fast execution, complete control, reliable testing
- **Why**: Pure logic should be testable without external concerns

**Data Processing & Utilities:**
- **Unit Testing**: Minimal dependencies, test data fixtures
- **Focus**: Input/output correctness, transformation accuracy
- **Benefits**: Predictable test data, isolated behavior verification

**Example - API Testing:**
```python
# ✅ Integration testing for API endpoints
from myapp.app import create_app  # Real app
from unittest.mock import patch

def test_api_endpoint():
    app = create_app()
    with patch('myapp.database.get_user') as mock_db:  # Mock external deps
        mock_db.return_value = {"id": 1, "name": "test"}
        client = TestClient(app)  # Test real routing/validation
        response = client.get("/api/users/1")
        assert response.status_code == 200
```

---

## 4 ✍️ Commit Drafting

After completing a sub‑task:

1. Draft a Conventional Commit header:
   ```
   feat({FEATURE_SLUG}): Short description
   ```
2. In the body, include a bullet list of sub‑tasks:
   ```
   - Add X functionality
   - Update tests for Y
   ```
3. Stage, commit, and push:
   ```bash
   git add .
   git commit -m "$(cat .git/COMMIT_EDITMSG)"
   git push
   ```

---

## 5 📄 Multi-level Documentation

Your context prompt generates three abstraction levels:

<details><summary>👶 Level 1 · Novice summary</summary>

Use this for a quick onboarding view.

</details>

<details><summary>🛠️ Level 2 · Key API table</summary>

Deep dive for power users.

</details>

<details><summary>🔍 Level 3 · Code walk-through</summary>

Detailed implementation details with annotated source.

</details>

---

## 6 📝 Docstring Standard

All functions must use **NumPy-style docstrings**:

```python
def foo(arg1, arg2):
    """
    Short description.

    Parameters
    ----------
    arg1 : type
        Description.
    arg2 : type
        Description.

    Returns
    -------
    type
        Description.

    Raises
    ------
    Exception
        Description.
    """
    ...
```

---

## 7 🔍 PR Review Bundle

Before merging:

1. Paste the PR bundle into ChatGPT or Claude Agent.
2. Address feedback and make adjustments.
3. Merge and delete the branch.

---

## 8 🤖 Agent Autonomy Boundaries

The agent may run commands (push, commit), but will:

1. Output a diff-stat of changes.
2. Await your approval before finalizing the commit or merge.

---

## 9 ⚙️ Settings & Linting

* Lint using **Flake8**.
* Commit messages follow **Conventional Commits**.
* Docstrings follow **NumPy style**.

---

## 10 Extending This Framework

1. Keep prompts in VCS; refine as needed.
2. Add new templates for recurring jobs (DB migration, API client generation, etc.).
3. Share improvements back to your LAD repo.

Enjoy faster, safer feature development with VS Code + Copilot + ChatGPT using the LAD framework!

---

### 3.3d Regression Prevention Strategy

**The LAD framework prevents the common "fix-break-fix" cycle** through systematic regression testing:

**Pre-flight Checks:**
- **Full test suite baseline**: Ensures starting point is stable
- **Coverage tracking**: Monitors test coverage before changes
- **Dependency analysis**: Understands impact before modifications

**During Development:**
- **Minimal scope changes**: Only modify code required for failing test
- **Continuous regression testing**: Run affected tests after each change
- **Interface preservation**: Maintain backward compatibility for public APIs

**Quality Gates:**
- **Final regression test**: Full test suite before commit
- **Impact assessment**: Verify no unintended side effects
- **Coverage maintenance**: Ensure coverage doesn't decrease

**Common Anti-Patterns Avoided:**
- ❌ Making changes without running existing tests
- ❌ Modifying shared utilities without impact analysis
- ❌ Changing public APIs without updating callers
- ❌ Committing without full test suite validation

**Best Practices:**
- ✅ Always run full test suite before starting (baseline)
- ✅ Run affected tests after each change (continuous)
- ✅ Use dependency analysis before modifying shared code
- ✅ Maintain test coverage throughout development
- ✅ Final full test suite before commit (validation)
