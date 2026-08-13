ms="$ANANKE_CMD_DURATION"
if ((ms < 1000)); then
  printf '%dms' "$ms"

elif ((ms < 60000)); then
  tenthsec=$(((ms + 50) / 100))
  second=$((tenthsec / 10))
  decimal=$((tenthsec % 10))
  printf '%d.%ds' "$second" "$decimal"

else
  minutes=$((ms / 60000))
  seconds=$(((ms % 60000) / 1000))

  printf '%dm%02ds' "$minutes" "$seconds"
fi
