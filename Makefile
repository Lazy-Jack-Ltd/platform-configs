.PHONY: help generate-models generate-ts generate-swift generate-kotlin generate-go validate-schemas clean

help:
	@echo "platform-configs — type-safe model generation via QuickType"
	@echo ""
	@echo "Targets:"
	@echo "  generate-models   Generate TypeScript models for every schema"
	@echo "  generate-ts       Alias for generate-models"
	@echo "  generate-swift    Generate Swift models"
	@echo "  generate-kotlin   Generate Kotlin models"
	@echo "  generate-go       Generate Go models"
	@echo "  validate-schemas  Confirm every schema is QuickType-consumable"
	@echo "  clean             Remove generated/"
	@echo ""
	@echo "QuickType is invoked via npx — no global install required."

generate-models: generate-ts

generate-ts:
	@echo "Generating TypeScript models..."
	@mkdir -p generated/ts
	@for schema in JSON/Schemas/*.schema.json; do \
		base=$$(basename $$schema .schema.json); \
		name=$$(echo $$base | awk '{ printf toupper(substr($$0,1,1)) substr($$0,2) }'); \
		echo "  $$schema -> generated/ts/$$base.ts (top-level: $$name)"; \
		npx --yes quicktype --src-lang schema --lang ts \
			--top-level "$$name" \
			"$$schema" \
			-o "generated/ts/$$base.ts" || exit 1; \
	done
	@echo "Done. See generated/ts/"

generate-swift:
	@echo "Generating Swift models..."
	@mkdir -p generated/swift
	@for schema in JSON/Schemas/*.schema.json; do \
		base=$$(basename $$schema .schema.json); \
		name=$$(echo $$base | awk '{ printf toupper(substr($$0,1,1)) substr($$0,2) }'); \
		npx --yes quicktype --src-lang schema --lang swift \
			--top-level "$$name" \
			"$$schema" \
			-o "generated/swift/$$base.swift" || exit 1; \
	done
	@echo "Done. See generated/swift/"

generate-kotlin:
	@echo "Generating Kotlin models..."
	@mkdir -p generated/kotlin
	@for schema in JSON/Schemas/*.schema.json; do \
		base=$$(basename $$schema .schema.json); \
		name=$$(echo $$base | awk '{ printf toupper(substr($$0,1,1)) substr($$0,2) }'); \
		npx --yes quicktype --src-lang schema --lang kotlin \
			--top-level "$$name" \
			"$$schema" \
			-o "generated/kotlin/$$base.kt" || exit 1; \
	done
	@echo "Done. See generated/kotlin/"

generate-go:
	@echo "Generating Go models..."
	@mkdir -p generated/go
	@for schema in JSON/Schemas/*.schema.json; do \
		base=$$(basename $$schema .schema.json); \
		name=$$(echo $$base | awk '{ printf toupper(substr($$0,1,1)) substr($$0,2) }'); \
		npx --yes quicktype --src-lang schema --lang go \
			--top-level "$$name" \
			"$$schema" \
			-o "generated/go/$$base.go" || exit 1; \
	done
	@echo "Done. See generated/go/"

validate-schemas:
	@echo "Validating schemas are QuickType-consumable..."
	@for schema in JSON/Schemas/*.schema.json; do \
		echo "  $$schema"; \
		npx --yes quicktype --src-lang schema --lang ts \
			--top-level Probe \
			"$$schema" \
			-o /dev/null || { echo "  FAILED: $$schema is not QuickType-consumable"; exit 1; }; \
	done
	@echo "All schemas pass."

clean:
	rm -rf generated/
