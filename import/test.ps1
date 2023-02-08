az keyvault list --query "[?tags.environment=='production']" --output json | jq -r '.[] | .name'

random addition




from feature branch