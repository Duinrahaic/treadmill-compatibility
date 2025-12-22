# Treadmill Compatibility Database

Authoritative treadmill compatibility data for:

- **FitOSC**
- **VRTI**

## Quick Start

```bash
# Install dependencies
npm install

# Validate individual treadmill files
npm run validate

# Compile dataset
npm run compile

# Validate compiled dataset
npm run validate:compiled
```

## Project Structure

```
data/
  treadmills/          # Individual treadmill JSON files
  treadmills.json      # Compiled dataset (auto-generated)
schema/
  treadmill.schema.json    # Individual file schema
  features.schema.json     # Feature flags schema
  treadmills.schema.json   # Compiled dataset schema
scripts/
  compile.js           # Compiles individual files into dataset
  install-hooks.sh     # Installs git pre-commit hooks
```

## Data Rules

- One treadmill per JSON file in `data/treadmills/`
- Feature flags are boolean (true/false)
- Driver is required
- Source must be a store or manufacturer product page
- Optional fields (`weight`, `speedRange`) are omitted if unknown
- No nulls or placeholder values
- Compiled dataset is auto-generated (don't edit manually)

## Adding a New Treadmill

1. Create a new JSON file in `data/treadmills/` (e.g., `brand-model.json`)
2. Follow the schema defined in `schema/treadmill.schema.json`
3. Commit your changes - the pre-commit hook will automatically:
   - Run `compile.js` to update `data/treadmills.json`
   - Validate all schemas
   - Include the compiled file in your commit

### Example Treadmill File

```json
{
  "id": "brand-model",
  "make": "Brand",
  "model": "Model Name",
  "driver": "Driver Name",
  "source": {
    "name": "Official Store",
    "url": "https://example.com/product"
  },
  "features": {
    "bluetooth": true,
    "ftms": false,
    "speed_read": true,
    "speed_control": true,
    "incline_read": false,
    "incline_control": false,
    "distance": true,
    "steps": false,
    "cadence": false,
    "calories": false,
    "heart_rate": false,
    "remote_start": false
  },
  "applications": {
    "fitosc": {
      "supported": false,
      "notes": []
    },
    "vrti": {
      "supported": true,
      "notes": ["Works with v2.0+"]
    }
  },
  "sharedNotes": []
}
```

## Git Hooks

The project uses a pre-commit hook to ensure the compiled dataset stays in sync:

- **Auto-installed**: Runs automatically after `npm install` (via `prepare` script)
- **Manual install**: Run `bash scripts/install-hooks.sh`
- **What it does**: When you commit changes to `data/treadmills/*.json`, it automatically runs `compile.js` and includes the updated `data/treadmills.json` in your commit

## CI/CD Workflow

GitHub Actions automatically validates all changes:

1. ✅ Validates individual treadmill JSON files against schema
2. ✅ Compiles the dataset
3. ✅ Validates the compiled dataset
4. ✅ Checks that the compiled file is up-to-date

## Schema Validation

All data is validated using JSON Schema (Draft 7) with AJV:

- URI format validation for source URLs
- Required fields enforcement
- Type checking for all properties
- Additional properties blocked (strict mode)

## Contributing

Missing specs are intentional - we only include verified data.

If you have verified specifications for a treadmill:

1. Fork the repository
2. Add/update the treadmill JSON file
3. Commit (hooks will auto-compile)
4. Open a Pull Request

All PRs must pass schema validation in CI before merging.
