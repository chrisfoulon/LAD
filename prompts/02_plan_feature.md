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

* **Hidden rationale**  
  Prepend a `<reasoning>` block (it will be stripped before commit) with one paragraph explaining *why* this plan is sound.

* **Resources** – bullet list of files to open, external APIs or libs.

* **Risks & Mitigations** – bullet list of likely pitfalls and fixes.

* **Acceptance-Checks** – table: test-file ║ key assertion ║ metric  
  (e.g. `flake8` < 10 cyclomatic, `MAPE < 0.1`, runtime ≤ 30 s).

---

**Deliverable** : the full plan printed above **and** written to `docs/{{FEATURE_SLUG}}/plan.md`.
</user>
