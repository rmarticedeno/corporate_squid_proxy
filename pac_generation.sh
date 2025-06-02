readarray -t arr < ./allowed_hostnames
PART1="function FindProxyForURL(url, host) {
  domains = ["
result=""
separator=","
for element in "${arr[@]}"; do
    result+="$element$separator"
done
result="${result%${separator}}"9
