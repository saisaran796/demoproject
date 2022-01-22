#!/bin/bash
some_text="Function to conversion of excel sheet into Data frame"
echo $some_text

cat <<EOF | python3 -
# import pandas lib as pd 
import pandas as pd
import xml.etree.cElementTree as ET
import requests
 
# read by default 1st sheet of an excel file
df1 = pd.read_excel (r'./jenkins/Individual_parameter_coverage.xlsx')
print(df1)
xml_data = open(r'./jenkins/config.xml').read()  # Read file
def xml2df(xml_data):
#...
for i, child in enumerate(root): #Begin looping through our root tree
record = {} #Place holder for our record
for subchild in child: #iterate through the subchildren to user-agent, Ex: ID, String, Description.
record[subchild.tag] = subchild.text #Extract the text create a new dictionary key, value pair
all_records.append(record) #Append this record to all_records.
# Flatten all key, value pairs to one large dictionary
all_records = {k: v for d in all_records for k, v in d.items()}
# Convert to DataFrame, index=[0] is required when passing dictionary
xml_df = pd.DataFrame(all_records, index=[0])
return xml_df
EOF
