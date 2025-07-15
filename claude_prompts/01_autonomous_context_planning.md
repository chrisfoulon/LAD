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

### Phase 2: Test-Driven Planning with Model Optimization

**Instructions**: Create a comprehensive TDD plan using TodoWrite for progress tracking, with intelligent model selection for optimal cost and performance.

1. **Task Complexity Assessment**: Evaluate feature complexity for appropriate model selection:
   
   **Complexity Indicators**:
   - **Simple** (→ Claude Haiku 3.5): Documentation, typos, basic queries, file operations, simple refactoring
   - **Medium** (→ Claude Sonnet 4): Feature implementation, test writing, moderate refactoring, API integration
   - **Complex** (→ Claude Opus 4): Architecture design, security analysis, performance optimization, system integration
   - **Extended** (→ Claude Sonnet 3.7/4): Multi-step planning, complex debugging, optimization analysis

   **Assessment Output**:
   ```
   **Task Complexity**: [SIMPLE|MEDIUM|COMPLEX|EXTENDED]
   **Recommended Model**: [model-name]
   **Rationale**: [brief-explanation]
   **Cost Impact**: [estimated-relative-cost]
   ```

2. **Task Breakdown**: Use TodoWrite to create prioritized task list with model assignments:
   ```python
   TodoWrite([
       {"id": "1", "content": "Task description with test file [Model: haiku-3.5]", "status": "pending", "priority": "high"},
       {"id": "2", "content": "Next task [Model: sonnet-4]", "status": "pending", "priority": "medium"}
   ])
   ```

3. **Plan Document**: Create `docs/{{FEATURE_SLUG}}/plan.md` with:
   - Top-level checklist (3-7 atomic tasks)
   - Sub-task breakdown (2-5 sub-tasks each) with model recommendations
   - Testing strategy per component type
   - Risk assessment and mitigation
   - Acceptance criteria mapping
   - Cost optimization summary

4. **Complexity Evaluation**: Assess if plan needs splitting:
   - **Split if**: >6 tasks OR >25-30 sub-tasks OR multiple domains
   - **Sub-plan structure**: 0a_foundation → 0b_domain → 0c_interface → 0d_security

### Phase 3: Self-Review & Validation

**Instructions**: Validate your plan using structured self-review with multi-model validation option.

1. **Completeness Check**:
   - Every acceptance criterion maps to at least one task
   - All dependencies properly sequenced
   - Testing strategy appropriate for component types
   - Model selections optimize cost/performance balance

2. **Risk Assessment**:
   - Identify potential concurrency, security, performance issues
   - Validate resource accessibility
   - Check for missing edge cases
   - Assess model selection appropriateness

3. **Cross-Validation Assessment**: Determine if additional validation is needed:
   - **Recommend cross-validation if**: Complex architecture, security concerns, performance critical, or user requests
   - **Cross-validation process**: Use different model to review plan for blind spots and alternative approaches

4. **Variable Persistence**: Save to `docs/{{FEATURE_SLUG}}/feature_vars.md`:
   ```bash
   FEATURE_SLUG={{FEATURE_SLUG}}
   PROJECT_NAME={{PROJECT_NAME}}
   TASK_COMPLEXITY={{TASK_COMPLEXITY}}
   PRIMARY_MODEL={{PRIMARY_MODEL}}
   # Additional variables as needed
   ```

### Deliverables

**Output the following**:
1. **Context Documentation**: Multi-level codebase understanding
2. **TodoWrite Task List**: Prioritized implementation tasks with model assignments
3. **Implementation Plan**: Detailed TDD plan with testing strategy and model optimization
4. **Variable Map**: Persistent feature configuration
5. **Sub-plan Structure**: If complexity warrants splitting
6. **Model Selection Summary**: Cost/performance optimization rationale

**Quality Gates**:
- All referenced files/APIs validated as accessible
- Testing strategy matches component types (integration/unit)
- Plan complexity manageable or properly split
- Clear dependency ordering established
- Model selections appropriate for task complexity
- Cost optimization balanced with quality requirements

**Next Steps**:
- If cross-validation recommended, proceed to Phase 1b (Plan Review & Validation)
- If plan approved, proceed to Phase 2 (Iterative Implementation)
- If complexity requires splitting, create sub-plans with appropriate model selections

</user>