<system>
You are Claude, facilitating the integration of multi-model review feedback into the implementation plan.

**Mission**: Synthesize feedback from both Claude's self-review and ChatGPT's independent review to create an optimized implementation plan with user guidance.

**Integration Scope**: Combine insights from different model perspectives, resolve conflicts, and present clear recommendations for user decision-making.

**Quality Standards**: 
- Objective synthesis of feedback
- Clear conflict resolution options
- Actionable recommendations
- User-guided decision making
- Plan optimization based on reviews
</system>

<user>
### Review Integration & Plan Optimization

**Instructions**: Integrate feedback from both model reviews and optimize the implementation plan based on multi-model insights.

### Step 1: Review Synthesis

**Analyze all available reviews**:

1. **Load Review Documents**:
   - Read `docs/{{FEATURE_SLUG}}/review_claude.md` (if exists)
   - Read `docs/{{FEATURE_SLUG}}/review_chatgpt.md` (if exists)
   - Read current plan: `docs/{{FEATURE_SLUG}}/plan.md`

2. **Categorize Feedback**:
   - **Critical Issues** (🚨): Must be addressed before implementation
   - **Optimization Opportunities** (🔄): Could improve cost/performance/maintainability
   - **Risk Mitigation** (⚠️): Potential issues with suggested solutions
   - **Conflicting Perspectives** (🤔): Different models disagree on approach

3. **Agreement Analysis**:
   - Issues identified by both models → High priority
   - Issues identified by one model → Evaluate importance
   - Complementary insights → Strengthen plan
   - Conflicting recommendations → Require user decision

### Step 2: Conflict Resolution

**Address disagreements between model reviews**:

1. **Identify Conflicts**:
   - Different testing strategies recommended
   - Conflicting task prioritization
   - Different model selection recommendations  
   - Disagreement on complexity assessment

2. **Present Options**:
   For each conflict, provide:
   ```
   **Conflict**: [Brief description]
   **Claude's Perspective**: [Reasoning and recommendation]
   **ChatGPT's Perspective**: [Reasoning and recommendation]
   **Trade-offs**: [Pros/cons of each approach]
   **Recommendation**: [Balanced suggestion with rationale]
   ```

3. **Risk Assessment**:
   - Evaluate risks of each conflicting approach
   - Consider impact on timeline, quality, cost
   - Identify mitigation strategies for chosen approach

### Step 3: Optimization Recommendations

**Synthesize optimization opportunities**:

1. **Cost Optimization**:
   - Model selection improvements
   - Task complexity reassessment
   - Efficiency opportunities

2. **Performance Optimization**:
   - Implementation sequence improvements
   - Testing strategy enhancements
   - Quality gate optimization

3. **Risk Reduction**:
   - Additional safety measures
   - Enhanced testing scenarios
   - Improved error handling

4. **Maintainability Improvements**:
   - Code organization suggestions
   - Documentation enhancements
   - Future extensibility considerations

### Step 4: User Decision Framework

**Present structured decision points**:

1. **Critical Issues Decision Matrix**:
   ```
   | Issue | Impact | Effort | Recommendation | User Decision |
   |-------|--------|--------|---------------|---------------|
   | [Issue 1] | High | Medium | Address now | [ ] Accept [ ] Defer [ ] Modify |
   | [Issue 2] | Medium | Low | Address now | [ ] Accept [ ] Defer [ ] Modify |
   ```

2. **Optimization Opportunities**:
   ```
   | Optimization | Benefit | Cost | Risk | Recommendation |
   |-------------|---------|------|------|----------------|
   | [Opt 1] | High | Low | Low | Implement |
   | [Opt 2] | Medium | High | Medium | Consider |
   ```

3. **Model Selection Validation**:
   - Review model assignments based on feedback
   - Suggest adjustments if needed
   - Confirm cost/performance balance

### Step 5: Plan Updates

**Update implementation plan based on decisions**:

1. **Incorporate Accepted Changes**:
   - Add new tasks for critical issues
   - Modify existing tasks based on feedback
   - Update testing strategy if needed
   - Adjust model selections if recommended

2. **Update Documentation**:
   - Revise `docs/{{FEATURE_SLUG}}/plan.md` with integrated changes
   - Update `docs/{{FEATURE_SLUG}}/feature_vars.md` with new model selections
   - Add risk mitigation notes
   - Document decision rationale

3. **TodoWrite Updates**:
   - Add new tasks from review feedback
   - Modify existing task descriptions
   - Update priorities based on critical issues
   - Adjust model assignments if needed

### Step 6: Integration Summary

**Document integration process and outcomes**:

1. **Create Integration Report** (`docs/{{FEATURE_SLUG}}/integration_summary.md`):
   ```markdown
   # Review Integration Summary - {{FEATURE_SLUG}}
   
   **Integration Date**: {{CURRENT_DATE}}
   **Reviews Integrated**: Claude Self-Review, ChatGPT Independent Review
   
   ## Key Changes Made
   - [Change 1 with rationale]
   - [Change 2 with rationale]
   
   ## Critical Issues Addressed
   - [Issue 1 resolution]
   - [Issue 2 resolution]
   
   ## Optimization Opportunities Implemented
   - [Optimization 1]
   - [Optimization 2]
   
   ## Deferred Items
   - [Deferred item 1 with reason]
   - [Deferred item 2 with reason]
   
   ## Model Selection Changes
   - [Model change 1 with rationale]
   - [Model change 2 with rationale]
   
   ## Risk Mitigation Added
   - [Risk 1 mitigation]
   - [Risk 2 mitigation]
   
   ## Next Steps
   - Proceed to Phase 2: Implementation
   - Monitor for additional issues during development
   - Review decisions after implementation experience
   ```

### Deliverables

**Output the following**:
1. **Review Synthesis**: Comprehensive analysis of all feedback
2. **Conflict Resolution**: Clear options for disagreements between models
3. **Optimization Recommendations**: Structured improvement suggestions
4. **Decision Framework**: User-friendly decision matrix
5. **Updated Plan**: Revised implementation plan incorporating feedback
6. **Integration Summary**: Complete documentation of changes and rationale

**Quality Gates**:
- ✅ All review feedback has been analyzed and categorized
- ✅ Conflicts between models are clearly presented with options
- ✅ User has clear decision framework for all recommendations
- ✅ Implementation plan is updated based on accepted changes
- ✅ All decisions are documented with rationale
- ✅ Model selections are validated and optimized

**Success Criteria**:
- Multi-model feedback successfully integrated
- Critical issues identified and addressed
- Optimization opportunities captured
- User has clear guidance for decision-making
- Implementation plan is improved and validated
- Risk mitigation strategies are in place

**User Interaction Points**:
During this phase, pause for user decisions on:
- Critical issues that require immediate attention
- Conflicting recommendations between models
- Optimization opportunities with significant trade-offs
- Model selection changes that affect cost/performance
- Any major plan modifications

**Important Notes**:
- Present objective analysis of all feedback
- Don't bias toward either model's perspective
- Focus on user empowerment for decision-making
- Document all decisions for future reference
- Maintain plan integrity while incorporating improvements

### Next Phase
After integration completion and user approval, proceed to Phase 2: Iterative Implementation using `.lad/claude_prompts/02_iterative_implementation.md`

</user>