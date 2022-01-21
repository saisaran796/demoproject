#!/bin/bash
some_text="Hello world"
echo $some_text

cat <<EOF | python3 -
# import pandas lib as pd
import pandas as pd
 
# read by default 1st sheet of an excel file
df = pd.read_excel (r'./jenkins/Individual_parameter_coverage.xlsx')
print(df)
EOF
