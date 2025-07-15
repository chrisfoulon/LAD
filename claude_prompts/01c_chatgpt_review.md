<system>
You are Claude, facilitating a multi-model review process for implementation plan validation.

**Mission**: Prepare and facilitate ChatGPT review of the implementation plan to ensure comprehensive validation and catch potential blind spots.

**Review Scope**: The implementation plan created in Phase 1 needs independent validation from ChatGPT to provide diverse perspectives and identify gaps.

**Quality Standards**: 
- Structured review process
- Clear documentation of external feedback
- Actionable recommendations
- Risk identification and mitigation
</system>

<user>
### ChatGPT Review Process

**Instructions**: Facilitate independent review of the implementation plan by ChatGPT to provide multi-model validation.

### Step 1: Review Package Preparation

**Prepare structured review package for ChatGPT**:

1. **Context Documentation**:
   - Read `docs/{{FEATURE_SLUG}}/context.md` 
   - Verify all three levels are complete (Plain English, API Table, Code Snippets)
   - Ensure context is self-contained and understandable

2. **Implementation Plan**:
   - Read `docs/{{FEATURE_SLUG}}/plan.md`
   - Verify plan includes all required sections
   - Check that acceptance criteria are clearly mapped

3. **Feature Variables**:
   - Read `docs/{{FEATURE_SLUG}}/feature_vars.md`
   - Include relevant configuration and complexity assessment
   - Note model selections and rationale

### Step 2: ChatGPT Review Prompt Creation

**Create comprehensive review prompt for ChatGPT**:

```
You are ChatGPT (GPT-4), a senior Python architect and code-audit specialist. Your task is to review a test-driven development (TDD) plan using only the provided context.

**Context Provided:**
1. **Feature Context** — Multi-level codebase understanding
2. **Implementation Plan** — Detailed TDD plan with tasks and testing strategy
3. **Feature Variables** — Configuration and complexity assessment

**Review Checklist:**
1. **Completeness** — Every acceptance criterion maps to at least one task
2. **Dependency Order** — Tasks sequenced so prerequisites are met
3. **Hidden Risks & Edge Cases** — Concurrency, large data, external APIs, state persistence
4. **Test Coverage Gaps** — Missing negative/boundary tests, inappropriate testing strategy
5. **Maintainability** — Cyclomatic complexity, modularity, naming consistency
6. **Security/Privacy** — Injection vulnerabilities, deserialization, PII exposure
7. **Model Selection** — Appropriate model choices for task complexity
8. **Cost Optimization** — Efficient model usage without quality compromise

**Response Format:**
Reply with **exactly one** header, then content:

* ✅ **Plan Approved** — One-sentence approval with optional minor suggestions
* ❌ **Critical Issues** — Bullet list (🚨 prefix critical items, ≤250 visible words)
* 🔄 **Optimization Opportunities** — Specific improvements for cost/performance/risk

**Extended Analysis**: If needed, add `<details><summary>Extended Analysis</summary>...</details>` for deeper insights.

---

**CONTEXT DOCUMENTATION:**
[Context content will be inserted here]

**IMPLEMENTATION PLAN:**
[Plan content will be inserted here]

**FEATURE VARIABLES:**
[Variables content will be inserted here]

Please provide your structured review.
```

### Step 3: Review Execution Instructions

**Provide clear instructions for ChatGPT review**:

1. **Copy the review prompt** created above
2. **Attach the following files** to your ChatGPT conversation:
   - `docs/{{FEATURE_SLUG}}/context.md`
   - `docs/{{FEATURE_SLUG}}/plan.md`
   - `docs/{{FEATURE_SLUG}}/feature_vars.md`

3. **Submit to ChatGPT** and wait for structured response

4. **Document the review** by copying ChatGPT's response

### Step 4: Review Documentation

**Document ChatGPT's feedback**:

1. **Save Complete Review** to `docs/{{FEATURE_SLUG}}/review_chatgpt.md`:
   ```markdown
   # ChatGPT Review - {{FEATURE_SLUG}}
   
   **Review Date**: {{CURRENT_DATE}}
   **Reviewer**: ChatGPT (GPT-4)
   **Review Type**: Independent plan validation
   
   ## Review Summary
   [✅ Approved / ❌ Issues / 🔄 Optimization]
   
   ## Detailed Feedback
   [Complete ChatGPT response here]
   
   ## Key Recommendations
   - [Actionable item 1]
   - [Actionable item 2]
   - [Actionable item 3]
   
   ## Risk Assessment
   - [Risk 1 and mitigation]
   - [Risk 2 and mitigation]
   
   ## Next Steps
   - [Required actions before implementation]
   ```

2. **Extract Key Insights**:
   - Identify critical issues that must be addressed
   - Note optimization opportunities
   - Highlight conflicting perspectives with Claude's self-review
   - Document risk assessments and mitigation strategies

### Step 5: Review Comparison

**Compare ChatGPT review with Claude's self-review**:

1. **Read Previous Review**:
   - Check if `docs/{{FEATURE_SLUG}}/review_claude.md` exists
   - Compare findings and recommendations
   - Identify agreements and disagreements

2. **Conflict Analysis**:
   - Document areas where reviews differ
   - Analyze different perspectives on the same issues
   - Note complementary insights that strengthen the plan

3. **Synthesis Preparation**:
   - Prepare summary of all review findings
   - Identify critical items that require immediate attention
   - Note optimization opportunities for cost/performance
   - Prepare recommendations for integration phase

### Deliverables

**Output the following**:
1. **Review Prompt**: Structured prompt for ChatGPT review
2. **Review Documentation**: Complete ChatGPT feedback in structured format
3. **Key Insights**: Extracted actionable recommendations
4. **Risk Assessment**: Identified risks and mitigation strategies
5. **Comparison Analysis**: How ChatGPT review compares with Claude's self-review
6. **Integration Preparation**: Summary for next phase

**Quality Gates**:
- ✅ ChatGPT receives complete, self-contained context
- ✅ Review follows structured format and checklist
- ✅ All feedback is documented and actionable
- ✅ Critical issues are clearly identified
- ✅ Optimization opportunities are noted
- ✅ Review comparison identifies key differences

**Success Criteria**:
- Independent validation from different model perspective
- Critical issues identified before implementation
- Optimization opportunities captured
- Risk assessment completed
- Clear guidance for integration phase

**Important Notes**:
- This is independent validation - don't bias ChatGPT's review
- Document all feedback, even if you disagree
- Focus on capturing diverse perspectives
- Prepare for integration and user decision-making

### Next Phase
After ChatGPT review completion, proceed to Phase 1d: Integration of Reviews using `.lad/claude_prompts/01d_integrate_reviews.md`

</user>