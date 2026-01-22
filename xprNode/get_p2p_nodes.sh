#!/bin/bash

# Requires: curl, jq
# If the API is unavailable or returns nothing, a static fallback list will be used

API_URL="https://danemarkbp.com/apis/get_json.php?status=active&type=p2p"

echo "Checking p2p nodes, this may take a few minutes...."

# Get the directory where the script is located
script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

# ---------- Fallback static list (from xpr.start README) ----------
fallback_addresses=(
  "api.protonnz.com:9876"
  "proton.protonuk.io:9876"
  "proton.p2p.eosusa.io:9879"
  "proton.cryptolions.io:9876"
  "protonp2p.eoscafeblock.com:9130"
  "p2p.alvosec.com:9876"
  "p2p.totalproton.tech:9831"
  "mainnet.brotonbp.com:9876"
  "proton.eu.eosamsterdam.net:9103"
  "protonp2p.blocksindia.com:9876"
  "p2p-protonmain.saltant.io:9876"
  "protonp2p.ledgerwise.io:23877"
  "proton-seed.eosiomadrid.io:9876"
  "proton.edenia.cloud:9879"
  "proton.genereos.io:9876"
  "peer-proton.nodeone.network:9870"
  "p2p.proton.eoseoul.io:39876"
  "proton-public.neftyblocks.com:19876"
  "p2p-proton.eosarabia.net:9876"
)

# ---------- Try to fetch the p2p list from API ----------
addresses=()

have_curl=false
have_jq=false
command -v curl >/dev/null 2>&1 && have_curl=true
command -v jq   >/dev/null 2>&1 && have_jq=true

if $have_curl && $have_jq; then
  api_list=$(curl -sS --max-time 10 "$API_URL" \
    | jq -r '.[] | select(.type=="p2p" and .status=="active") | .url' 2>/dev/null)

  if [[ -n "$api_list" ]]; then
    declare -A seen
    while IFS= read -r line; do
      norm="${line#p2p://}"
      if [[ -n "$norm" && -z "${seen[$norm]}" ]]; then
        addresses+=("$norm")
        seen[$norm]=1
      fi
    done <<< "$api_list"
  fi
else
  echo "Warning: 'curl' and/or 'jq' not found. Using fallback list."
fi

# If API returned nothing, use fallback
if [[ ${#addresses[@]} -eq 0 ]]; then
  echo "API returned no usable nodes (or request failed). Using fallback list."
  addresses=("${fallback_addresses[@]}")
else
  echo "Loaded ${#addresses[@]} P2P nodes from API."
fi

# ---------- Check availability and measure latency ----------
declare -A latencies

for address in "${addresses[@]}"; do
  host="${address%%:*}"
  ping_output=$(ping -c 1 -W 2 "$host" 2>/dev/null)

  if [[ $? -eq 0 ]]; then
    latency=$(echo "$ping_output" | grep -oE 'time=[0-9.]+' | cut -d= -f2)
    if [[ -n "$latency" ]]; then
      latencies["$address"]=$latency
    else
      echo "Could not parse latency for: $address"
    fi
  else
    echo "P2P Node unavailable: $address"
  fi
done

# ---------- Save and display result ----------
output_file="$script_dir/available_nodes.txt"
> "$output_file"

for address in $(for key in "${!latencies[@]}"; do echo "${latencies[$key]} $key"; done | sort -n | awk '{print $2}'); do
  latency=${latencies[$address]}
  {
    echo "#(latency: $latency ms)"
    echo "p2p-peer-address = $address"
  } >> "$output_file"
done

if [[ -s "$output_file" ]]; then
  cat "$output_file"
else
  echo "No available P2P nodes detected."
fi
