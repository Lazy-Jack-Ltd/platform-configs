# platform-configs

Open-source JSON configuration data originating from
[Lazy-Jack Ltd](https://github.com/Lazy-Jack-Ltd) platforms
(BIPCircle, ID-Circle). Role taxonomies, audit-action vocabularies,
JSON Schemas, and other non-proprietary configuration data.

## Current state (2026-04-16)

**This repo is scaffolding — no config files are published yet.**

All BIPCircle JSON configs are currently flagged `oss:false` pending
Nick Vermeulen's ecosystem-wide review of what Lazy-Jack Ltd wants
to publish alongside OpenKYCAML. The scaffolding (README, Makefile,
CI, QuickType examples) is in place so that the moment approvals
land, a single `.meta.json` flip-plus-sync publishes the first wave
of configs.

The private mirror at `Lazy-Jack-Ltd/ID-Circle-Core/JSON/BIPCircle-Configs/`
and `.../JSON/BIPCircle-Schemas/` carries all 18 current configs.
Once Nick approves specific files for public release, they'll
appear here via `npm run sync-configs` from the BIPCircle repo.

## Why this repo exists

Lazy-Jack Ltd's compliance + financial-platform ecosystem maintains
many JSON configurations that are structurally **generic** — role
name vocabularies, audit event taxonomies, JSON Schema contracts —
and some subset of these is safe to open-source. Keeping them here
lets:

- Downstream consumers (mobile apps, SDKs, integrators) auto-generate
  type-safe models from the schemas (see Generating models below).
- Third parties reference the same role / audit-action vocabulary
  Lazy-Jack's platforms use, aiding compatibility.
- Contributions flow back through a public review process.

**Proprietary** configurations stay in the private mirror
`Lazy-Jack-Ltd/ID-Circle-Core`. Per the fail-closed default, a config
is private unless its `.meta.json` in the BIPCircle source repo
explicitly declares `oss: true` with a `public_target`. The scaffolding
below is ready to receive whichever files get approved.

## Layout

```
JSON/
  Roles/              — Role taxonomies (role names + hierarchy + aliases)
  Audit-Actions/      — Audit action vocabularies (event names + severity)
  Schemas/            — JSON Schema (Draft 2020-12) contracts for all data files
generated/            — Auto-generated type-safe models (gitignored by default;
                        committed per language directory if operators opt in)
```

Each data file has a matching `*.schema.json` in `JSON/Schemas/`.
Data files are valid against their schema; CI enforces this on
every PR.

## Sourcing + versioning

Files are mirrored from upstream BIPCircle commits via the
`scripts/sync-configs-to-upstream.js` sync in the BIPCircle repo.
Each sync commit message cites the BIPCircle source SHA so
downstream consumers can trace the origin.

The sync is manual (not post-merge-hook yet) — new config additions
land here when the upstream owner runs `npm run sync-configs`.
Version policy: the upstream source of truth is BIPCircle `main`.
Tagged releases here track upstream semantic milestones.

## Generating type-safe models from these schemas

All schemas in this repo are JSON Schema (Draft 2020-12). Consume
via [QuickType](https://quicktype.io) for type-safe models in your
language of choice. QuickType is open-source (Apache-2.0) and
produces deterministic output — same schema in, same code out.

### Command-line examples

**TypeScript**
```bash
npx quicktype --src-lang schema \
  --lang ts \
  --top-level Role \
  JSON/Schemas/roles.schema.json \
  -o Role.ts
```

**Swift**
```bash
npx quicktype --src-lang schema \
  --lang swift \
  --top-level AuditAction \
  JSON/Schemas/auditDefinitions.schema.json \
  -o AuditAction.swift
```

**Kotlin**
```bash
npx quicktype --src-lang schema \
  --lang kotlin \
  --top-level SagaDefinition \
  JSON/Schemas/sagaDefinitions.schema.json \
  -o SagaDefinition.kt
```

Supported QuickType languages include TypeScript, Swift, Kotlin,
Go, C#, Python, Java, Rust, Ruby, Dart, Elm, Haskell, and more.
See `quicktype --help` for the full list.

### Using the Makefile

A convenience `Makefile` at the repo root generates all-schemas-
at-once for TypeScript:

```bash
make generate-models
```

Output lands in `generated/ts/`. Extend the Makefile with
`generate-swift`, `generate-kotlin`, etc. for your language. PRs
that add languages are welcome.

### Reference

Nick Vermeulen's detailed workflow for model generation from
JSON Schema lives at
`Lazy-Jack-Ltd/OpenKYCAML-Private/manuals/creating-data-models.md`
(private; ask for access). One JSON Schema of his has produced
~157,000 lines of deterministic, type-safe model code across
multiple languages — this repo uses the same pattern.

## Contribution

1. **Open an issue first.** Describe the change (new role, new
   audit action, schema extension) and link the upstream use case.
2. Get agreement on the shape in the issue thread.
3. **Then open a PR.** PRs without prior issue discussion may be
   closed.
4. Every PR must pass CI: schemas must parse with QuickType, data
   files must validate against their schema.
5. Substantive changes may require coordination with the upstream
   BIPCircle repository — the sync script is one-way (downstream),
   so contributions accepted here get back-ported upstream manually.

## License

[MIT](./LICENSE) — see file.

## Related

- [BIPCircle](https://github.com/Lazy-Jack-Ltd/bipcircle) — upstream
  source of truth (private; compliance-heavy fork of the configs).
- [ID-Circle-Core](https://github.com/Lazy-Jack-Ltd/ID-Circle-Core)
  — private downstream mirror carrying both OSS and proprietary
  configs for internal tooling.
- [QuickType](https://quicktype.io) — the recommended consumer
  toolchain.
