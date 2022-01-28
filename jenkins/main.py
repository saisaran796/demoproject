from openpyxl import Workbook, load_workbook
from openpyxl.styles import PatternFill, Side, borders, Font, Alignment
import xml.etree.ElementTree as ET


def psm_xml():
    xml_parameter = []
    root = ET.parse(r'./jenkins/config.xml').getroot()
    for child in root.iter('Parameter'):
        xml_parameter.append(child.attrib['obj'].strip())
    return xml_parameter


def txt_extract() :
    text_file =r"./jenkins/Psm_coverage_psm_dev.txt"
    words= {}
    with open(text_file,"r") as file:
        data = file.readlines()
        try :
            for index,line in enumerate(data):
                if index > 5 :
                    keys =line.split(" ")[0]
                    value=float(line.split(" ")[-1])
                    if keys not in words.keys() :
                        words[keys] = []
                        words[keys].append(value)
                    else:
                        words[keys].append(value)
        except :
            pass

    text_data = {}
    for coverage_key in words:
        coverage_value = sum(words[coverage_key])*100/len(words[coverage_key])
        text_data[coverage_key] = coverage_value

    # print("txt Data",(text_data))
    return text_data


a = txt_extract()
print(a)
def xl_parameters():
    wb = load_workbook(r"./jenkins/Individual_parameter_coverage.xlsx")
    ws = wb["Sheet1"]

    start_row = 0
    start_col = 0

    for row in ws:
        for cell in row:
            if cell.value == "Parameter Name":
                start_row = cell.row
                start_col = cell.column

    parameter_name = {}
    for row in range(start_row + 1, ws.max_row):
        s = ws.cell(row=row, column=start_col)
        parameter_name[s.value] = ws.cell(row=row, column=start_col+1).value
    del parameter_name[None]

    # print("xl Data",parameter_name)
    return parameter_name


def missing_parameter():
    missing_parameters = []
    name = "Missing Parameters"
    excel = xl_parameters()
    xfj = psm_xml()
    for i in excel.keys():
        if i not in xfj:
            missing_parameters.append(i)
    xl_writing(name, missing_parameters)


def coverage_results():
    # diff = DeepDiff (xl_parameters(), txt_extract())
    # print(diff)
    sheet_name = "Coverage Results"
    result = []
    for i in txt_extract().keys():
        if i in xl_parameters().keys():
            if txt_extract()[i] > xl_parameters()[i]:
                result.append((i, xl_parameters()[i], txt_extract()[i]))

    if len(txt_extract()) > len(result):
        return False
    xl_writing(sheet_name, result)


def xl_writing(sheet_name, values):
    side = Side(border_style="thick")
    border = borders.Border(
        left=side,
        right=side,
        top=side,
        bottom=side,
    )

    wb2 = Workbook()
    ws2 = wb2.create_sheet(sheet_name, 0)

    ws2["B2"] = sheet_name
    ws2["B2"].font = Font(color="ffffff", size="18", bold=True)
    ws2["B2"].fill = PatternFill("solid", start_color="0458AB")
    ws2['B2'].alignment = Alignment(horizontal='center', vertical='center')

    ws2['B3'] = "Parameter Name"
    ws2['B3'].alignment = Alignment(horizontal='center', vertical='center')
    ws2['C3'] = "Coverage Ratio(%)"
    ws2['C3'].alignment = Alignment(horizontal='center', vertical='center')
    ws2['B3'].fill = PatternFill("solid", start_color="96be25")
    ws2['B3'].font = Font(color="000000", size="11", bold=True)
    ws2['C3'].fill = PatternFill("solid", start_color="96be25")
    ws2['C3'].font = Font(color="000000", size="11", bold=True)

    if sheet_name == "Missing Parameters":
        ws2.merge_cells("B2:C2")
        ws2['C2'].border = border
        s = values
        for row in range(0, len(s)):
            for col in range(1, 2):
                ws2[chr(66)+str(row + 4)] = s[row]
                ws2[chr(67) + str(row + 4)] = xl_parameters()[s[row]]
    else:
        ws2.merge_cells("B2:D2")
        ws2.merge_cells("C3:D3")
        ws2.merge_cells("B3:B4")
        ws2["B2"].border = border
        ws2['C2'].border = border
        ws2['B4'].border = border
        ws2['D2'].border = border
        ws2['D3'].border = border
        ws2['D4'].border = border
        ws2["C4"].value = "Actual"
        ws2['C4'].fill = PatternFill("solid", start_color="96be25")
        ws2["D4"].value = "Result"
        ws2['D4'].fill = PatternFill("solid", start_color="96be25")

        s = values

        for row in range(0, len(s)):
            for col in range(1, 3):
                ws2[chr(66) + str(row + 5)] = s[row][0]
                ws2[chr(67) + str(row + 5)] = s[row][1]
                ws2[chr(68) + str(row + 5)] = s[row][2]

    ws2.column_dimensions["B"].width, ws2.column_dimensions["C"].width,ws2.column_dimensions["D"].width = 42, 18, 15
    # print(ws2.max_row,ws2.max_column)

    for row in range(1, ws2.max_row+1):
        for col in range(1, ws2.max_column+1):
            if ws2.cell(row=row, column=col).value:
                ws2.cell(row=row, column=col).border = border

    ws2.sheet_view.showGridLines = False
    # wb2.save(r"C:/Users/saran/Desktop/code/Result_Parameters.xlsx")


coverage_results()
# missing_parameter()
