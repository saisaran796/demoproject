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
def xml2df(xml_data, leave_out=[]):

#Initiates the tree Ex: <user-agents>

tree = ET.parse(xml_data)

#Starts the root of the tree Ex: <user-agent>

root = tree.getroot()

#This is our record list which we will convert into a dataframe

all_records = []

#Subchildren tags will be parsed and appended here

headers = []

#Begin looping through our root tree

for i, child in enumerate(root):

record = []

#iterate through the subchildren to user-agent, Ex: ID, String, Description

for subchild in child:

#This is my modification, if a record that we don't want to include in the data framework

#is detected just skeep it

if subchild.text in leave_out:

break

#Extract the text and append it to our record list

record.append(subchild.text)

#Check the header list to see if the subchild tag <id>, <string>...

#is in our headers field. If not append it. This will be used for our headers

if subchild.tag not in headers:

headers.append(subchild.tag)

#Append this record to all_records, only if the record is not empty

if record != []:

all_records.append(record)

#Finally, return our Pandas dataframe with headers in the column

return pd.DataFrame(all_records, columns=headers)
EOF
