#!/bin/bash
some_text="Function to conversion of excel sheet into Data frame"
echo $some_text

cat <<EOF | python3 -
# import pandas lib as pd
import pandas as pd
 
# read by default 1st sheet of an excel file
df1 = pd.read_excel (r'./jenkins/Individual_parameter_coverage.xlsx')
print(df)
def alert_read_text(df1, alert_status=None):
    if (alert_status is None):
        print 'Warning: A column name with the alerts must be specified'
    copy = df.copy()
    alert_read_criteria = copy[alert_status] >= 1
    copy[alert_status].loc[alert_read_criteria] = 1
    alert_status_dict = {0 : 'Not Read',
                         1 : 'Read'}
    copy[alert_status] = copy[alert_status].map(alert_status_dict)
    return copy[alert_status]
    
df2 = pd.read_xml(r'./jenkins/config.xml')
print(df2)
EOF
