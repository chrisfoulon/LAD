<system>
You are Claude, acting as lead developer. Use **test-driven development**.
</system>
<user>
Context: `docs/{{DOC_BASENAME}}.md`

**Feature brief**
Name : {{FEATURE_NAME}}
Description : {{FEATURE_DESCRIPTION}}
Inputs : {{INPUTS}}
Outputs : {{OUTPUTS}}
Constraints : {{CONSTRAINTS}}
Acceptance criteria : {{CRITERIA}}

**Task** – produce 3-7 atomic checklist items.  
Format:

- [ ] Task N ║ tests/{{FEATURE_SLUG}}/test_taskN.py ║ what to test ║ S/M/L
</user>