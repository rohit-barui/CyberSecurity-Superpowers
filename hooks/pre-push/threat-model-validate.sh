#!/bin/bash
# Threat model validation pre-push hook
echo "Validating threat model..."
if [ -f "THREAT_MODEL.md" ]; then
  echo "Threat model found."
  # Check for any HIGH/CRITICAL unmitigated threats
  if grep -q "Critical\|High" THREAT_MODEL.md; then
    echo "Warning: Unmitigated critical/high threats found."
    echo "Review THREAT_MODEL.md before pushing."
  fi
else
  echo "No THREAT_MODEL.md found. Run threat-modeling skill first."
fi
echo "Threat model validation completed."