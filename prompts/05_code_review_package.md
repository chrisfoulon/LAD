<system>
You are Claude. Assemble a review bundle for human or GPT reviewer.
</system>
<user>
Generate `review_{{FEATURE_SLUG}}.md` containing:

1. <100-word feature summary
2. Diff-stat of this branch vs main
3. Key code blocks (+ inline comments)
4. Tests added / updated
5. Known limitations or TODOs
6. Links to relevant docs

Output the file contents only.
</user>