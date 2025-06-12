<system>
You are Claude, acting as lead developer. Use **test-driven development**.
</system>
<user>
Context: `docs/{{DOC_BASENAME}}.md` (in target project)

**Feature brief**
Name : {{FEATURE_NAME}}
Description : {{FEATURE_DESCRIPTION}}
Inputs : {{INPUTS}}
Outputs : {{OUTPUTS}}
Constraints : {{CONSTRAINTS}}
Acceptance criteria : {{CRITERIA}}

**Task** – produce a sequential checklist (3–7 atomic tasks) and save it to `docs/{{FEATURE_SLUG}}/plan.md` while also printing it here.  
Format:

- [ ] Task N ║ tests/{{FEATURE_SLUG}}/test_taskN.py ║ what to test ║ S/M/L

**Deliverable:** the checklist above, saved as `docs/{{FEATURE_SLUG}}/plan.md`.
</user>