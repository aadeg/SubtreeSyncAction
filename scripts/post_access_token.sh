curl \
    -v \
    -X POST \
    -H "Authorization: Bearer ${JWT_TOKEN}" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/app/installations/${INSTALLATION_ID}/access_tokens \
    -d '{}'