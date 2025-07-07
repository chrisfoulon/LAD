# LLM‑Assisted‑Development (LAD) Framework

> **Goal**  Provide a repeatable recipe**Guardrails:** The **04_implement_next_task.md** prompt now includes:
  - A **Scope Guard** to only touch code required by the current failing test.
  - **Forbidden Actions** that prevent deletion of existing functions/classes unless they are 0% covered *and* absent from docs, with an explicit "Delete <name>? (y/n)" confirmation.
  - A prompt for the user to run coverage **outside VS Code**, then verify 0% coverage and Level-2 API docs before any removal. ready‑to‑paste prompt templates so you can ask **GitHub Copilot Claude Agent** (in VS Code) to:
>
> 1. **Understand** a target slice of a large Python code‑base.
> 2. **Plan** a feature via test‑driven, step‑wise decomposition.
> 3. **Review** that plan (Claude & ChatGPT Plus).
> 4. **Implement** each sub‑task in tiny, self‑documenting commits while keeping tests green **and updating docs**.
> 5. **Merge & clean up** using a lightweight GitHub Flow.
>
> Works **today** with zero extra infra – no vector DB, only Copilot / ChatGPT Plus.

---

## 1 Repository Skeleton

```
├── .copilot-instructions.md        # global style/context guidelines (see §6)
├── README.md                       # quick‑start for humans
├── LAD_RECIPE.md                   # this file – full workflow
├── prompts/
│   ├── 00_feature_kickoff.md
│   ├── 01_context_gathering.md
│   ├── 02_plan_feature.md
│   ├── 03_review_plan.md
│   ├── 03b_integrate_review.md
│   ├── 03_chatgpt_review.md
│   ├── 04_implement_next_task.md
│   ├── 05_code_review_package.md
│   └── 06_self_review_with_chatgpt.md
└── .vscode/
    ├── settings.json               # pytest, coverage, flake8
    └── extensions.json             # optional helpers
```

Import the complete `.lad/` directory into any target project once on main.

* Target Python 3.11.
* Commit messages follow Conventional Commits.
* All generated docs follow the *plain summary + nested `<details>`* convention.

---

## 2 Quick‑Setup Checklist

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

## 3 End‑to‑End Workflow

| # | Action                                                             | Prompt                                                 |
| - | ------------------------------------------------------------------ | ------------------------------------------------------ |
| 0 | **Kick‑off** · import kit & gather clarifications                  | `00_feature_kickoff.md`                                |
| 1 | Gather context → multi‑level docs                                  | `01_context_gathering.md`                              |
| 2 | Draft test‑driven plan                                             | `02_plan_feature.md`                                   |
| 3 | Claude plan review                                                 | `03_review_plan.md`                                    |
| 3b| Integrate Copilot & ChatGPT reviews + evaluate plan splitting      | `03b_integrate_review.md`                              |
| 3c| ChatGPT cross-validation                                           | `03_chatgpt_review.md`                                 |
| 4 | Implement **next** task → commit & push (supports sub-plans)       | `04_implement_next_task.md`                            |
| 4b| **Regression Recovery** (when tests break during implementation)   | `04b_regression_recovery.md`                           |
| 5 | ChatGPT self-review (optional)                                     | `06_self_review_with_chatgpt.md`                       |
| 6 | Compile review bundle → ChatGPT                                    | `05_code_review_package.md`                            |
| 7 | **Open PR** via `gh pr create`                                     | (shell)                                                |
| 8 | **Squash‑merge & delete branch** via `gh pr merge --delete-branch` | (shell)                                                |

### 3.3b Plan Splitting for Complex Features

**When plan complexity becomes unmanageable** (>6 tasks, >25-30 sub-tasks, mixed domains), the `03b_integrate_review.md` prompt automatically evaluates for plan splitting:

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
