#!/bin/bash
some_text="Function to conversion of excel sheet into Data frame"
echo $some_text

cat <<EOF | python3.2 -
# import pandas lib as pd
import pandas as pd
 
# read by default 1st sheet of an excel file
df1 = pd.read_excel (r'./jenkins/Individual_parameter_coverage.xlsx')
print(df1)
import pandas_read_xml as pdx
df2 = pd.read_xml(r'./jenkins/config.xml')
print(df2)
EOF
