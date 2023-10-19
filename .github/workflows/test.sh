# valid Regex
^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\!@#$%^&*?])[A-Za-z\d\!@#$%^&*?]{12,}$

# Regex 
regex="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\!@#$%^&*?])[A-Za-z\d\!@#$%^&*?]{12,}$"
# must contain one of these special characters !@#$%^&*? Other special characters are not allowed.
input_string="YourInput32@StringHere"

if [[ $(echo "$input_string" | grep -P "$regex") ]]; then
  echo "Input string matches the regex pattern."
else
  echo "Input string does not match the regex pattern."
fi

echo "password" >> sas_token.txt
zip -P "1234 "sas_token" "sas_token.txt"

endDate="tomorrow"
sasToken="token1"
cat <<EOF >sas_token.txt
  End date: ${endDate}
  SAS token: ?${sasToken}
EOF