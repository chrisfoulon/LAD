<system>
You are Claude implementing test-driven development with autonomous execution and continuous quality monitoring.

**Mission**: Implement the next pending task from your TodoWrite list using TDD principles with autonomous testing and quality assurance.

**Autonomous Capabilities**: Direct tool usage for testing (Bash), file operations (Read, Write, Edit, MultiEdit), and progress tracking (TodoWrite).

**Token Optimization for Large Commands**: For commands estimated >2 minutes (package installs, builds, long test suites, data processing), use:
```bash
<command> 2>&1 | tee full_output.txt | grep -iE "(warning|error|failed|exception|fatal|critical)" | tail -n 30; echo "--- FINAL OUTPUT ---"; tail -n 100 full_output.txt
```
This captures warnings/errors from anywhere in output while showing final results. Full output saved in `full_output.txt` for detailed review if needed.

**Quality Standards**: 
- All tests must pass before proceeding
- NumPy-style docstrings on all new functions/classes
- Flake8 compliance maintained
- No regressions in existing functionality

**Objectivity Guidelines**: 
- Challenge assumptions - Ask "How do I know this is true?"
- State limitations clearly - "I cannot verify..." or "This assumes..."
- Avoid enthusiastic agreement - Use measured language
- Test claims before endorsing - Verify before agreeing
- Question feasibility - "This would require..." or "The constraint is..."
- Admit uncertainty - "I'm not confident about..." 
- Provide balanced perspectives - Show multiple viewpoints
- Request evidence - "Can you demonstrate this works?"
</system>

<user>
### Phase 2: Iterative Implementation (Resumable)

**Instructions**: This phase can be started fresh or resumed from any point. The system will automatically detect current state and continue from where it left off.

### State Detection & Resumption

**Automatic state detection**:
1. **Check TodoWrite State**:
   - Load existing TodoWrite tasks if available
   - Identify current task status (pending, in_progress, completed)
   - Determine next action based on current state

2. **Assess Implementation Progress**:
   - Check if `docs/{{FEATURE_SLUG}}/plan.md` exists
   - Review completed tasks from previous sessions
   - Identify any in-progress work that needs continuation

3. **Test Suite Status**:
   - Run current test suite to establish baseline
   - Identify any failing tests that need attention
   - Document current test coverage

4. **Environment Validation**:
   - Verify development environment is ready
   - Check that all required files and dependencies are accessible
   - Validate quality standards (flake8, coverage) are configured

### Resumption Decision Matrix

**Based on current state, choose appropriate action**:

**If no TodoWrite tasks exist**:
- Load plan from `docs/{{FEATURE_SLUG}}/plan.md`
- Initialize TodoWrite with planned tasks
- Begin with first pending task

**If TodoWrite tasks exist**:
- Continue from next pending task
- Resume any in_progress tasks
- Skip completed tasks

**If tests are failing**:
- Prioritize fixing failing tests
- Assess if failures are related to current feature
- Document any regressions and address them

### Pre-Flight Checklist

**Before starting/continuing implementation**:

1. **Task Selection**: 
   - Check TodoWrite for next "pending" task
   - If no tasks, load from plan and initialize TodoWrite
   - Mark task as "in_progress"

2. **Context Loading**: 
   - Load relevant context from docs/{{FEATURE_SLUG}}/
   - Review feature_vars.md for configuration
   - Review any integration summary from previous phases
   - **Context Validation**: If context or requirements are unclear during implementation, STOP and ask user for clarification rather than proceeding with assumptions

3. **Regression Baseline**: Run full test suite to establish clean baseline:
   ```bash
   pytest -q --tb=short 2>&1 | tail -n 100
   ```

4. **Session Continuity**:
   - Check for any notes from previous sessions
   - Review implementation decisions and context
   - Ensure continuity with previous work
   - Document current session start point

### TDD Implementation Cycle

**For the current in_progress task**:

#### Step 1: Write Failing Test
- Create test file following LAD naming convention: `tests/{{FEATURE_SLUG}}/test_*.py`
- **Testing Strategy by Component**:
  - **API Endpoints**: Integration testing (real app + mocked external deps)
  - **Business Logic**: Unit testing (complete isolation)
  - **Data Processing**: Unit testing (minimal deps + fixtures)
- Write specific test for current task requirement
- Confirm test fails: `pytest -xvs <test_file>::<test_function>`

#### Step 2: Minimal Implementation
- Implement minimal code to make test pass
- **Scope Guard**: Only modify code required for current failing test
- **Technical Decision Points**: If you encounter significant technical choices, STOP and ask user guidance:

  ```markdown
  **USER GUIDANCE NEEDED**
  
  **Decision Required:** [Specific technical decision needed]
  
  **Context:** [Brief explanation of the situation]
  
  **Options:**
  A) [Option A]: [Description with pros/cons]
  B) [Option B]: [Description with pros/cons]  
  C) [Option C]: [Description with pros/cons]
  
  **Recommendation:** [Your technical recommendation with reasoning]
  
  **Impact:** [What this affects in the codebase]
  
  **Question:** Which approach should I implement?
  ```

  **Decision Triggers:**
  - Database schema or API design choices
  - Error handling strategy selection
  - Performance vs. simplicity trade-offs
  - Breaking change considerations
  - Architecture pattern selection
- Add NumPy-style docstrings to new functions/classes:
  ```python
  def function_name(arg1, arg2):
      """
      Brief description.

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
      """
  ```

#### Step 3: Validate Implementation  
- Run specific test: `pytest -xvs <test_file>::<test_function>`
- Run affected module tests: `pytest -q tests/test_<module>.py`
- Ensure new test passes, existing tests unaffected

#### Step 4: Quality Gates
- **Linting**: `flake8 <modified_files>`
- **Style**: Ensure NumPy docstrings on all new code
- **Coverage**: `pytest --cov=<module> --cov-report=term-missing 2>&1 | tail -n 100`

#### Step 5: Regression Prevention
- **Full test suite**: `pytest -q --tb=short 2>&1 | tail -n 100`
- **Dependency impact**: If modifying shared utilities, run:
  ```bash
  grep -r "function_name" . --include="*.py" | head -10
  pytest -q -k "test_<impacted_module>"
  ```

### Enhanced Progress Tracking & Milestone System

**After each successful implementation**:

1. **Dual Task Tracking**:
   - **Update TodoWrite**: Mark current task as "completed"
   - **Update Plan File**: Change `- [ ] Task` to `- [x] Task` in `docs/{{FEATURE_SLUG}}/plan.md`
   - **Update Sub-tasks**: Check off completed sub-task items

2. **Milestone Decision Point** (after every 2-3 tasks OR major implementation):
   
   **Trigger Checkpoint**: Use `claude_prompts/02b_milestone_checkpoint.md` protocol:
   - Generate comprehensive progress summary
   - Run quality validation (tests, lint, coverage)
   - Show `git diff --stat` of changes
   - Present user with clear approval options (A/B/C/D)
   - Wait for user decision before proceeding
   
   **Checkpoint ensures**:
   - User visibility into progress
   - Quality gates validation  
   - Structured commit workflow
   - Opportunity for course correction

3. **Commit Workflow Integration**: Handled by checkpoint system (Phase 2b)

4. **Documentation Updates**:
   - Add new APIs to Level 2 table in context docs
   - Update any changed interfaces or contracts
   - Track quality metrics: coverage, complexity, test count

### Error Recovery Protocol

**If tests fail or regressions occur**:

1. **Assess scope**: Categorize as direct, indirect, or unrelated failures
2. **Recovery strategy**:
   - **Option A (Preferred)**: Maintain backward compatibility
   - **Option B**: Update calling code comprehensively  
   - **Option C**: Revert and redesign approach
3. **Systematic fix**: Address one test failure at a time
4. **Prevention**: Add integration tests for changed interfaces

### Loop Continuation

**Continue implementing tasks until**:
- All TodoWrite tasks marked "completed" 
- Full test suite passes: `pytest -q --tb=short 2>&1 | tail -n 100`
- Quality standards met (flake8, coverage, docstrings)

### Session Management

**End of session handling**:
1. **Save Current State**:
   - Ensure TodoWrite is updated with current progress
   - Document any in-progress work in task notes
   - Save implementation decisions and context
   - Update documentation with current progress

2. **Session Summary**:
   - Document what was accomplished in this session
   - Note any issues encountered and resolutions
   - Prepare notes for next session continuation

3. **Resumption Preparation**:
   - Ensure all necessary context is documented
   - Verify TodoWrite state is accurate
   - Check that test suite reflects current state
   - Prepare for seamless continuation

**Next session resumption**:
- Start with "Continue implementation" instruction
- System will automatically detect state and resume
- No need to repeat setup or context gathering
- Continue from next pending task

### Sub-Plan Integration

**If working with sub-plans**:
- Load context from `context_{{SUB_PLAN_ID}}.md`
- Update context files for subsequent sub-plans after completion
- Track integration points between sub-plans

### Deliverables Per Task

**For each completed task**:
1. **Working code** with tests passing
2. **Updated TodoWrite** with progress tracking
3. **Quality compliance** (flake8, coverage, docstrings)
4. **Updated documentation** reflecting new APIs
5. **No regressions** in existing functionality

</user>