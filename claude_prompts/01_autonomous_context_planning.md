<system>
You are Claude, an expert software architect implementing test-driven development using autonomous exploration and planning.

**Mission**: Gather comprehensive context about the codebase and create a detailed implementation plan for the requested feature.

**Autonomous Capabilities**: You have access to tools for codebase exploration (Task, Glob, Grep), file operations (Read, Write, Edit), command execution (Bash), and progress tracking (TodoWrite).

**Quality Standards**: 
- NumPy-style docstrings required
- Flake8 compliance (max-complexity 10) 
- Test-driven development approach
- Component-aware testing (integration for APIs, unit for business logic)
- 90%+ test coverage target
</system>

<user>
**Feature Request**: {{FEATURE_DESCRIPTION}}

**Requirements**:
- Inputs: {{INPUTS}}
- Outputs: {{OUTPUTS}} 
- Constraints: {{CONSTRAINTS}}
- Acceptance Criteria: {{ACCEPTANCE_CRITERIA}}

### Phase 1: Autonomous Codebase Exploration

**Instructions**: Use your autonomous tools to understand the codebase architecture without requiring user file navigation.

1. **Architectural Understanding**:
   - Use Task tool for complex architectural questions
   - Use Glob to find relevant files and patterns
   - Use Grep to understand code patterns and APIs
   - Read key configuration and documentation files

2. **Context Documentation**: Create `docs/{{FEATURE_SLUG}}/context.md` with multi-level structure:
   
   **Level 1 (Plain English)**: Concise summary of relevant codebase components
   
   **Level 2 (API Table)**:
   | Symbol | Purpose | Inputs | Outputs | Side-effects |
   |--------|---------|--------|---------|--------------|
   
   **Level 3 (Code Snippets)**: Annotated code examples for key integration points

### Phase 2: Test-Driven Planning

**Instructions**: Create a comprehensive TDD plan using TodoWrite for progress tracking.

1. **Task Breakdown**: Use TodoWrite to create prioritized task list:
   ```python
   TodoWrite([
       {"id": "1", "content": "Task description with test file", "status": "pending", "priority": "high"},
       {"id": "2", "content": "Next task", "status": "pending", "priority": "medium"}
   ])
   ```

2. **Plan Document**: Create `docs/{{FEATURE_SLUG}}/plan.md` with:
   - Top-level checklist (3-7 atomic tasks)
   - Sub-task breakdown (2-5 sub-tasks each)
   - Testing strategy per component type
   - Risk assessment and mitigation
   - Acceptance criteria mapping

3. **Complexity Evaluation**: Assess if plan needs splitting:
   - **Split if**: >6 tasks OR >25-30 sub-tasks OR multiple domains
   - **Sub-plan structure**: 0a_foundation → 0b_domain → 0c_interface → 0d_security

### Phase 3: Self-Review & Validation

**Instructions**: Validate your plan using structured self-review.

1. **Completeness Check**:
   - Every acceptance criterion maps to at least one task
   - All dependencies properly sequenced
   - Testing strategy appropriate for component types

2. **Risk Assessment**:
   - Identify potential concurrency, security, performance issues
   - Validate resource accessibility
   - Check for missing edge cases

3. **Variable Persistence**: Save to `docs/{{FEATURE_SLUG}}/feature_vars.md`:
   ```bash
   FEATURE_SLUG={{FEATURE_SLUG}}
   PROJECT_NAME={{PROJECT_NAME}}
   # Additional variables as needed
   ```

### Deliverables

**Output the following**:
1. **Context Documentation**: Multi-level codebase understanding
2. **TodoWrite Task List**: Prioritized implementation tasks  
3. **Implementation Plan**: Detailed TDD plan with testing strategy
4. **Variable Map**: Persistent feature configuration
5. **Sub-plan Structure**: If complexity warrants splitting

**Quality Gates**:
- All referenced files/APIs validated as accessible
- Testing strategy matches component types (integration/unit)
- Plan complexity manageable or properly split
- Clear dependency ordering established

</user>