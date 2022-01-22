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
# convert an xml file into a list of dictionaries.
# each element of the list is a dictionary of all the (key: attribute) and (tag: text) pairs found in
# a path descending through XML tag layers before terminating at a tag with no children.
def parse_xml(root):
parsed_data = {}
# get data from attributes in the current tag
for key in root.keys():
parsed_data[key] = root.attrib.get(key)
# check if current level has children
if not root.getchildren():
return [parsed_data]
else:
child_list = []
has_children = False
# for each child, get data stored in the text
for child in root.getchildren():
if child.text:
parsed_data[child.tag] = child.text
if child.getchildren():
has_children = True
# if any child has children, continue the recursive parsing
if has_children:
for child in root.getchildren():
child_data = parse_xml(child)
# for each parsed child, take it's dictionary of values and add it the already-parsed data from
# higher level tags. One row of data per child of the current tag
for child_row_dict in child_data:
# combine two dictionaries and append to list of row-dictionaries
child_list.append({**parsed_data, **child_row_dict})
return child_list
else:
return [parsed_data]
xml_data = open('path/to/xml.xml').read()
root = et.XML(xml_data)
parsed_df = pd.DataFrame(data=parse_xml(root))
EOF
