# 

curl -v -i \
    -H "Authorization: Bearer ${JWT_TOKEN}" \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/app/installations

#orgs/HIPERT-SRL/installation