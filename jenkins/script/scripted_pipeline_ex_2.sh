#!/bin/bash
some_text="Hello world"
echo $some_text

cat <<EOF | python -
# import pandas lib as pd
import pandas as pd
 
# read by default 1st sheet of an excel file
dataframe1 = pd.read_excel('Individual_parameter_coverage.xlsx')
 
print(dataframe1)
EOF
