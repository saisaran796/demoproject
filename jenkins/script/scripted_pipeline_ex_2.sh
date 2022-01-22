#!/bin/bash
some_text="Function to conversion of excel sheet into Data frame"
echo $some_text

cat <<EOF | python3 -
# import pandas lib as pd 
import pandas as pd
import xml.etree.cElementTree as et
import requests
 
# read by default 1st sheet of an excel file
df1 = pd.read_excel (r'./jenkins/Individual_parameter_coverage.xlsx')
print(df1)
xml_data = open(r'./jenkins/config.xml').read()  # Read file
class XML2DataFrame:

    def __init__(self, xml_data):
        self.root = ET.XML(xml_data)

    def parse_root(self, root):
        """Return a list of dictionaries from the text and attributes of the
        children under this XML root."""
        return [parse_element(child) for child in root.getchildren()]

    def parse_element(self, element, parsed=None):
        """ Collect {key:attribute} and {tag:text} from thie XML
         element and all its children into a single dictionary of strings."""
        if parsed is None:
            parsed = dict()

        for key in element.keys():
            if key not in parsed:
                parsed[key] = element.attrib.get(key)
            if element.text:
                parsed[element.tag] = element.text                
            else:
                raise ValueError('duplicate attribute {0} at element {1}'.format(key, element.getroottree().getpath(element)))           

        """ Apply recursion"""
        for child in list(element):
            self.parse_element(child, parsed)
        return parsed

    def process_data(self):
        """ Initiate the root XML, parse it, and return a dataframe"""
        structure_data = self.parse_root(self.root)
        return pd.DataFrame(structure_data)

xml2df = XML2DataFrame(xml_data)
xml_dataframe = xml2df.process_data()
EOF
