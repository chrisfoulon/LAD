# Phase 0: Existing Work Discovery and Integration Assessment

## Purpose
Prevent duplicate implementations by discovering and assessing existing functionality before starting new development. This phase ensures architectural coherence and optimal resource utilization.

## Discovery Requirements

### 1. Codebase Scan
Search for existing implementations related to the requested feature:
- Use comprehensive search patterns (keywords, functionality, similar concepts)
- Examine API endpoints, services, modules, and utilities
- Check test files for functionality hints
- Review documentation for existing capabilities

### 2. Architecture Mapping
Identify current system components that might be relevant:
- Map existing services and their responsibilities
- Identify data models and schemas
- Document integration points and dependencies
- Assess current architectural patterns

### 3. Capability Assessment
Evaluate what already exists vs. what's needed:
- Compare existing functionality to new requirements
- Assess code quality, test coverage, and production readiness
- Identify gaps between current and required capabilities
- Document technical debt and improvement opportunities

### 4. Integration Decision
Decide whether to integrate, enhance, or build new:
- Apply Integration Decision Matrix (below)
- Consider long-term maintainability
- Evaluate impact on existing systems
- Plan deprecation strategy if needed

## Discovery Checklist
- [ ] **Keyword Search**: Search codebase for feature-related terms
- [ ] **API Analysis**: Review existing endpoints and services
- [ ] **Model Review**: Check data models and database schemas
- [ ] **Test Examination**: Analyze test files for functionality insights
- [ ] **Documentation Review**: Check README, API docs, and comments
- [ ] **Dependency Mapping**: Identify related components and libraries
- [ ] **Quality Assessment**: Evaluate code quality and test coverage
- [ ] **Integration Points**: Map how components connect
- [ ] **Performance Analysis**: Assess scalability and performance characteristics
- [ ] **Security Review**: Check authentication, authorization, and security patterns

## Integration Decision Matrix

| Existing Implementation Quality | Coverage of Requirements | Recommended Action | Justification |
|--------------------------------|-------------------------|-------------------|---------------|
| Production-ready, well-tested | 80%+ coverage | **INTEGRATE/ENHANCE** | Avoid duplication, build on solid foundation |
| Production-ready, well-tested | 50-80% coverage | **ENHANCE** | Extend existing with missing functionality |
| Production-ready, well-tested | <50% coverage | **ASSESS → ENHANCE or NEW** | Evaluate cost/benefit of extension vs. new |
| Prototype/incomplete | 80%+ coverage | **ENHANCE** | Complete and productionize existing work |
| Prototype/incomplete | 50-80% coverage | **ASSESS → ENHANCE or REBUILD** | Case-by-case evaluation based on architecture fit |
| Prototype/incomplete | <50% coverage | **BUILD NEW** | Start fresh with lessons learned |
| Poor quality/untested | Any coverage | **REBUILD** | Don't build on unstable foundation |
| No existing implementation | N/A | **BUILD NEW** | Justified new development |
| Conflicts with requirements | Any coverage | **BUILD NEW + DEPRECATION PLAN** | Document migration path |

## Assessment Report Template

### Existing Work Summary
- **Components Found**: [List relevant components]
- **Quality Level**: [Production/Development/Prototype/Poor]
- **Test Coverage**: [Percentage and quality]
- **Documentation Level**: [Complete/Partial/Missing]

### Requirements Mapping
- **Requirements Covered**: [List covered requirements]
- **Requirements Missing**: [List gaps]
- **Coverage Percentage**: [Overall coverage estimate]

### Architecture Compatibility
- **Integration Points**: [How new feature connects]
- **Dependencies**: [Required libraries/services]
- **Conflicts**: [Potential architectural issues]
- **Migration Needs**: [If replacing existing code]

### Decision and Rationale
- **Chosen Strategy**: [Integrate/Enhance/New]
- **Primary Reasons**: [Why this approach]
- **Risk Assessment**: [Implementation risks]
- **Success Metrics**: [How to measure success]

## Next Phase Preparation
Based on the discovery results:
1. **If INTEGRATE/ENHANCE**: Focus context planning on extension points
2. **If BUILD NEW**: Plan for coexistence and eventual migration
3. **If REBUILD**: Plan deprecation strategy and migration path

## Deliverables for Context Planning Phase
1. **Existing Work Assessment Report** (using template above)
2. **Integration Strategy Decision** with detailed rationale
3. **Architecture Impact Analysis** 
4. **Implementation Approach** (integrate/enhance/new with specific plan)

---
*This phase must be completed before proceeding to Phase 1: Autonomous Context Planning*