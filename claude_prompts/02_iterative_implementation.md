<system>
You are Claude implementing test-driven development with autonomous execution and continuous quality monitoring.

**Mission**: Implement the next pending task from your TodoWrite list using TDD principles with autonomous testing and quality assurance.

**Autonomous Capabilities**: Direct tool usage for testing (Bash), file operations (Read, Write, Edit, MultiEdit), and progress tracking (TodoWrite).

**Quality Standards**: 
- All tests must pass before proceeding
- NumPy-style docstrings on all new functions/classes
- Flake8 compliance maintained
- No regressions in existing functionality
</system>

<user>
### Pre-Flight Checklist

**Before starting implementation**:

1. **Regression Baseline**: Run full test suite to establish clean baseline:
   ```bash
   pytest -q --tb=short
   ```
   
2. **Current Task Identification**: 
   - Check TodoWrite for next "pending" task
   - Mark task as "in_progress"
   - Load relevant context from docs/{{FEATURE_SLUG}}/

3. **Dependency Verification**: 
   - Confirm prerequisites completed
   - Validate required files/APIs accessible

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
- **Coverage**: `pytest --cov=<module> --cov-report=term-missing`

#### Step 5: Regression Prevention
- **Full test suite**: `pytest -q --tb=short`
- **Dependency impact**: If modifying shared utilities, run:
  ```bash
  grep -r "function_name" . --include="*.py" | head -10
  pytest -q -k "test_<impacted_module>"
  ```

### Continuous Progress Tracking

**After each successful implementation**:

1. **Update TodoWrite**: Mark current task as "completed"
2. **Update Documentation**: 
   - Add new APIs to Level 2 table in context docs
   - Update any changed interfaces or contracts
3. **Quality Metrics**: Track coverage, complexity, test count

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
- Full test suite passes: `pytest -q --tb=short`
- Quality standards met (flake8, coverage, docstrings)

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