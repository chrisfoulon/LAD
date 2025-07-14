<system>
You are Claude, acting as lead developer. Use **test-driven development**.
</system>

<user>
Context : `docs/{{DOC_BASENAME}}.md` (in target project)

**Feature brief**
Name : {{FEATURE_NAME}}
Description : {{FEATURE_DESCRIPTION}}
Inputs : {{INPUTS}}
Outputs : {{OUTPUTS}}
Constraints : {{CONSTRAINTS}}
Acceptance criteria : {{CRITERIA}}

---

### Task – create a hierarchical TDD plan  
Produce a top-level checklist **(3–7 atomic tasks)**, print it here, **and save the same Markdown** to  
`docs/{{FEATURE_SLUG}}/plan.md`.

* **Checklist format**  
  `- [ ] Task N ║ tests/{{FEATURE_SLUG}}/test_taskN.py ║ what to test ║ S/M/L`  

* **Sub-steps**  
  Break each top-level task into 2 – 5 indented sub-tasks:  
  ```
  - [ ] 1.1 …  
    - [ ] 1.1.a …  (optional deeper level)
  ```

*After generating the top-level checklist, append the following block to the same Markdown file*:

```
<details><summary>📝 Extended Details (for ChatGPT / humans)</summary>

### Rationale
<reasoning>One-paragraph hidden rationale goes here.</reasoning>

### Resources
- Files to open: …
- External APIs / libs: …

### Risks & Mitigations
- 🚨 Risk A – Mitigation  
- Risk B – …

### Acceptance-Checks
| Test file                                   | Assertion                       | Metric                |
|---------------------------------------------|---------------------------------|-----------------------|
| tests/{{FEATURE_SLUG}}/test_task1.py        | Returns correct output          | flake8 < 10           |
| …                                           | …                               | runtime ≤ 30 s        |

### Testing Strategy
**For each task, specify the appropriate testing approach:**
- **API/Web Service tasks**: Integration testing (real app + mocked external deps)
- **Business Logic tasks**: Unit testing (complete isolation)
- **Data Processing tasks**: Unit testing (minimal deps + fixtures)

</details>
```

---

**Deliverable:** checklist printed above **plus** the extended `<details>` section, all saved to `docs/{{FEATURE_SLUG}}/plan.md`.
</user>
