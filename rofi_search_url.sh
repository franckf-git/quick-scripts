#! /bin/sh

declare -A URLS

URLS=(
  ["duckduckgo"]="https://www.duckduckgo.com/?q="
  ["youtube"]="https://www.youtube.com/results?search_query="
  ["wikipedia"]="https://fr.wikipedia.org/w/index.php?search="
)

# List for rofi
gen_list() {
    for i in "${!URLS[@]}"
    do
      echo "$i"
    done
}

main() {
  # Pass the list to rofi
  platform=$( (gen_list) | rofi -dmenu -matching fuzzy -only-match -location 0 -p "Search > " )

  query=$( (echo ) | rofi  -dmenu -matching fuzzy -location 0 -p "Query > " )
  if [[ -n "$query" ]]; then
    url=${URLS[$platform]}$query
    surf "$url"
  else
    rofi -show -e "No query provided."
  fi
}

main

exit 0