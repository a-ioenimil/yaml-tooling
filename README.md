# Application Configuration Quality Gate

This repository implements a **GitOps-oriented Quality Gate** for managing application configurations. It uses an automated GitHub Actions pipeline to ensure that strict engineering standards are met before any configuration changes are accepted.

## 🚀 Workflow Overview

Every time code is pushed or a Pull Request is opened, the `Config Quality Gate` workflow triggers to perform the following checks:

1.  **YAML Linting**: Validates the syntax of `app-config.yaml` using `yq`.
2.  **Security Audit**: Scans for hardcoded secrets. Specifically, it enforces that the database `password` field uses a variable substitution pattern (e.g., `${DB_PASSWORD}`) instead of plain text.
3.  **Transformation**: Automatically converts the validated YAML configuration into a machine-readable JSON format (`app-config.json`).
4.  **Deep Validation**: Verifies the integrity of the generated JSON using `jq`.
5.  **Artifact Generation**: The final, validated JSON file is archived as a build artifact, ready for deployment.

## 🛠️ Tools Used

- **[GitHub Actions](https://github.com/features/actions)**: Orchestrates the CI pipeline.
- **[yq (v4)](https://github.com/mikefarah/yq)**: A portable command-line YAML processor used for linting and conversion.
- **[jq](https://stedolan.github.io/jq/)**: A lightweight and flexible command-line JSON processor used for validation.

## � Local Development

One of the key features of this setup is that **you don't have to wait for the CI pipeline** to check your work. All validation logic is encapsulated in the `scripts/` directory.

### Running Checks Locally
Make sure the scripts are executable:
```bash
chmod +x scripts/*.sh
```

**Step 1: Make your changes to `app-config.yaml`**

**Step 2: Generate the JSON file locally**
```bash
./scripts/transform.sh app-config.yaml app-config.json
```

**Step 3: Run Validation Checks**
```bash
# Lint YAML
./scripts/lint.sh app-config.yaml

# Security Audit
./scripts/security-audit.sh app-config.yaml

# Verify Sync (Optional, confirming your JSON matches YAML)
./scripts/check-sync.sh app-config.yaml app-config.json
```

**Step 4: Commit both files**
```bash
git add app-config.yaml app-config.json
git commit -m "Update configuration"
```

## �🚨 How to Fix a Failed Build

If your pipeline fails, check the "Actions" tab logs to identify the stage that broke the build.

### Case 1: ❌ YAML Syntax Error
**Symptom:** The "Linting Stage" fails.
**Fix:**
- Ensure your indentation is correct (2 or 4 spaces, **no tabs**).
- Check for invalid characters or structure in `app-config.yaml`.
- Use a local validator or VS Code extension to check syntax before pushing.

### Case 2: ❌ Sync Check Failed
**Symptom:** The pipeline says "The committed JSON file does not match the YAML configuration."
**Fix:**
- You forgot to update `app-config.json` after changing `app-config.yaml`.
- Run: `./scripts/transform.sh app-config.yaml app-config.json`
- Commit and push the updated JSON file.

### Case 3: ❌ Security Risk Detected
**Symptom:** The "Security Audit" fails with a message about "plain-text".
**Fix:**
- **NEVER** commit real passwords to the repository.
- Change the `database.password` field to use an environment variable placeholder.
- **Incorrect:** `password: "superSecret123"`
- **Correct:** `password: "${DB_PASSWORD}"`

### Case 3: ❌ JSON Validation Failed
**Symptom:** transformation or deep validation fails.
**Fix:**
- This usually indicates the YAML is valid syntax but results in malformed data types (e.g., keys that shouldn't be null). Review the `Transformation Stage` logs.
