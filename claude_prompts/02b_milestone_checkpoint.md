# Phase 2b: Milestone Checkpoint & User Approval

## Purpose
Provide structured milestone checkpoints during implementation to ensure user visibility, gather feedback, and maintain development momentum with appropriate approval gates.

## When to Use This Phase
This checkpoint is triggered automatically during Phase 2 (Iterative Implementation) when:
- 2-3 tasks have been completed in sequence
- A major implementation milestone is reached
- Significant architectural or design decisions were made
- Quality gates indicate issues that need attention
- Before making breaking changes to existing code

## Pre-Checkpoint Assessment

### 1. Progress Summary Generation
**Automatically generate summary of completed work:**

```markdown
## MILESTONE CHECKPOINT: {{FEATURE_SLUG}}

### ✅ Completed This Session
{{#each completed_tasks}}
- [x] {{name}}: {{description}}
  {{#if subtasks}}
  {{#each subtasks}}
    - [x] {{name}}
  {{/each}}
  {{/if}}
{{/each}}

### 📊 Quality Status
- **Tests Status**: {{test_status}} ({{passing_tests}}/{{total_tests}} passing)
- **Lint Compliance**: {{lint_status}} ({{lint_issues}} issues)
- **Coverage**: {{coverage_percent}}% (target: 90%+)
- **Complexity**: {{complexity_score}} (target: <10)

### 🔄 Integration Status
- **Modified Files**: {{modified_files_count}} files
- **New Files**: {{new_files_count}} files  
- **Test Files**: {{test_files_count}} files
- **Documentation**: {{docs_status}}
```

### 2. Change Impact Assessment
**Show user what has changed:**

```bash
# Show staged and unstaged changes
git status --porcelain
git diff --stat --staged
git diff --stat
```

### 3. Quality Validation
**Run comprehensive quality checks:**

```bash
# Full test suite
pytest -q --tb=short

# Lint check on modified files  
flake8 {{modified_files}}

# Coverage report
pytest --cov={{feature_module}} --cov-report=term-missing --tb=no -q | tail -n 20
```

## User Interaction Protocol

### 1. Milestone Presentation
**Present clear, structured information to user:**

```markdown
**MILESTONE REACHED: {{milestone_description}}**

**Summary**: {{brief_summary_of_progress}}

**Quality Metrics**:
- Tests: {{status_icon}} {{details}}
- Lint: {{status_icon}} {{details}}
- Coverage: {{status_icon}} {{details}}

**Changes Made**:
{{git_diff_summary}}

**Next Planned Steps**:
{{#each upcoming_tasks}}
- [ ] {{name}}: {{description}}
{{/each}}
```

### 2. Approval Options
**Present clear choices to user:**

```markdown
**Please choose your next action:**

**A) ✅ APPROVE & COMMIT** - Everything looks good, commit and continue
   - Will commit changes with generated message
   - Will push to remote branch  
   - Will continue with next tasks

**B) 🔍 REVIEW NEEDED** - I need to examine the changes more closely
   - Will pause implementation
   - User can review code, run tests, check functionality
   - Will wait for explicit instruction to continue

**C) 🔧 MODIFICATIONS NEEDED** - Changes required before committing
   - Will pause implementation
   - User can specify what needs to be modified
   - Will implement requested changes before continuing

**D) 📝 COMMIT MESSAGE EDIT** - Approve changes but customize commit message
   - Will use user-provided commit message
   - Will commit and continue normally

**Your choice (A/B/C/D):**
```

### 3. Response Handling

#### Option A - Approve & Commit
```bash
# Generate descriptive commit message
COMMIT_MSG="feat({{FEATURE_SLUG}}): {{milestone_description}}

{{#each completed_tasks}}
- {{description}}
{{/each}}

🤖 Generated with Claude Code LAD Framework

Co-Authored-By: Claude <noreply@anthropic.com>"

# Execute commit workflow
git add -A
git commit -m "$COMMIT_MSG"
git push -u origin HEAD

# Continue implementation
echo "✅ Committed and pushed. Continuing with next tasks..."
```

#### Option B - Review Needed
```markdown
**Implementation Paused for Review**

**Current State**: All changes are staged and ready for review

**To resume implementation**, tell me:
- "Continue implementation" - Resume with next tasks
- "Implement [specific change]" - Make modifications then continue  
- "Commit and continue" - Commit current changes then continue

**For detailed review**:
- `git diff --staged` - See staged changes
- `pytest -v` - Run full test suite
- `flake8 .` - Check lint compliance
```

#### Option C - Modifications Needed
```markdown
**Implementation Paused for Modifications**

**Please specify what changes you'd like me to make:**

**Common modification requests:**
- "Refactor [function/class] to improve [specific aspect]"
- "Add error handling for [specific case]"  
- "Update tests to cover [specific scenario]"
- "Change API design for [specific endpoint]"
- "Improve performance of [specific operation]"

**After modifications**, I'll run quality checks and return to this checkpoint.
```

#### Option D - Custom Commit Message
```markdown
**Please provide your custom commit message:**

**Format suggestion:**
```
feat({{FEATURE_SLUG}}): [your description]

[optional body with details]
```

**I'll use your message and commit immediately.**
```

## Checkpoint Recovery
**If interrupted or resumed later:**

1. **Detect checkpoint state** from TodoWrite and plan files
2. **Regenerate progress summary** based on current state
3. **Validate quality status** with fresh test runs
4. **Present resumption options** to user

## Integration with TodoWrite
**Maintain dual tracking:**

```python
# Update TodoWrite with checkpoint status
TodoWrite([
    # Mark completed tasks
    {"id": "1", "content": "Task A", "status": "completed", "priority": "high"},
    # Mark current checkpoint task
    {"id": "checkpoint", "content": "Milestone checkpoint - awaiting user approval", 
     "status": "in_progress", "priority": "high"},
    # Keep pending tasks
    {"id": "3", "content": "Task C", "status": "pending", "priority": "medium"}
])
```

## Success Metrics
**Each checkpoint should achieve:**
- ✅ Clear progress visualization for user
- ✅ Quality validation completed  
- ✅ User feedback incorporated
- ✅ Appropriate commit/push action taken
- ✅ Implementation momentum maintained

---
*This phase ensures user stays informed and engaged throughout the implementation process*