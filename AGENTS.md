# Mandatory AI and engineering workflow

These instructions are mandatory for every AI agent and automated coding assistant working in `anatolie-ernu/wordpress-enterprise-security-platform`.

## Authority and sources of truth

Before proposing or making changes:

1. Read this file completely.
2. Read `docs/PROJECT_STATUS.md`.
3. Inspect the repository, current branch, working tree, relevant source, tests, deployment files, and CI workflows.
4. Read any project-specific roadmap, architecture, stage, release, security, or handover documents that apply.
5. Treat executable code, committed configuration, migrations, tests, and observed runtime evidence as stronger evidence than stale narrative documentation.
6. If sources conflict, report the conflict and resolve it in the same change when it is within scope.

Never invent files, endpoints, behavior, infrastructure, credentials, test results, deployment results, or project status.

## Scope discipline

- Implement only the confirmed objective and acceptance criteria.
- Preserve existing architecture, APIs, data contracts, visual design, and user changes unless the task explicitly requires a change.
- Do not add unsolicited features, redesigns, dependencies, frameworks, services, or broad refactors.
- Keep bug fixes minimal and reviewable.
- Ask for clarification only when a missing decision would materially change the implementation.
- Separate required work from optional improvements; do not perform optional work without approval.

## Mandatory execution workflow

1. Establish the baseline: branch, revision, relevant files, existing changes, and current behavior.
2. Define or confirm measurable acceptance criteria.
3. Reproduce the defect or confirm the missing behavior when feasible.
4. Identify the root cause using repository and runtime evidence.
5. Implement the smallest coherent change.
6. Add or update regression tests when feasible.
7. Run the smallest relevant validation first, then broader checks only when justified.
8. Inspect the final diff for accidental or unrelated changes.
9. Update `docs/PROJECT_STATUS.md` with factual evidence and remaining limitations.
10. Report the result using the mandatory completion format below.

For multi-component or high-risk work, prepare a plan before editing. Continue autonomously through safe, reversible steps until completion or a real blocker is reached.

## Validation and evidence

Always distinguish these states:

- inspected statically;
- formatted or linted;
- compiled or built;
- covered by automated tests;
- tested at runtime;
- tested on staging;
- tested on a real device or external integration;
- not verified.

A container or process being `Up`, `Running`, or `Healthy` is not sufficient proof that the application works.

Do not claim `done`, `functional`, `production-ready`, `secure`, or `verified on staging` without matching evidence.

After a bug fix, repeat the original reproduction steps. Report exact commands or CI workflows and their results. Never represent an unexecuted command as successful.

## Security, data, and operations

- Never commit secrets, credentials, private keys, tokens, dumps containing sensitive data, or real production personal data.
- Apply least privilege and preserve auditability.
- Database changes require a migration, compatibility assessment, and rollback or recovery approach.
- Deployment changes require preflight checks, service readiness checks, smoke tests, evidence collection, and rollback guidance.
- Backup work is incomplete without a documented restore path; where the task requires operational validation, test the restore safely.
- Production deployment, destructive actions, publishing, external messages, and irreversible operations require explicit authorization.
- Preserve existing user work and never use destructive Git or filesystem operations to remove unrelated changes.

## Testing strategy

Discover the real validation commands from the repository instead of inventing them. Prefer this order where applicable:

1. targeted unit or regression test;
2. formatter and linter for touched code;
3. component build or compile;
4. component test suite;
5. integration and contract tests;
6. container/configuration validation;
7. end-to-end or smoke tests;
8. staging/runtime/device validation.

If a required environment, runner, credential, service, or device is unavailable, state the limitation precisely and provide the exact next validation step.

## Documentation and status

`docs/PROJECT_STATUS.md` is the persistent handover record between work sessions. Update it in the same pull request whenever a task changes implementation status, validation evidence, blockers, or the next approved step.

Do not replace detailed existing roadmaps, stage histories, decision records, or test reports with a shorter summary. Link to them from the status file.

## Git and review policy

- Work on a dedicated branch unless explicitly instructed otherwise.
- One commit should represent one logical change.
- Use Conventional Commit messages where practical.
- Do not combine unrelated cleanup with a functional fix.
- Review the diff before committing or opening a pull request.
- Do not commit, push, open or merge a pull request, or deploy when the granted scope is read-only.
- Do not merge a pull request or deploy to production without explicit authorization.

## Mandatory completion report

Every final report must contain:

1. Outcome.
2. Root cause or implementation rationale.
3. Files changed.
4. Validation commands or workflows and actual results.
5. Security, compatibility, migration, and rollback impact where relevant.
6. Items not verified and why.
7. Remaining blockers.
8. The single next concrete step.

## Definition of Done

Work is Done only when:

- acceptance criteria are satisfied;
- the implementation matches repository conventions;
- relevant checks pass;
- regression coverage is added when feasible;
- no known unrelated changes are included;
- documentation and project status are current;
- runtime, staging, and device claims are backed by evidence;
- limitations and remaining risks are explicit.
