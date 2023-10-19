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



