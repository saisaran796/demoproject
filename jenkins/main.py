import pandas as pd
import xml.etree.cElementTree as ET
import requests
 
# read by default 1st sheet of an excel file
df1 = pd.read_excel (r'./jenkins/Individual_parameter_coverage.xlsx')
print(df1)
