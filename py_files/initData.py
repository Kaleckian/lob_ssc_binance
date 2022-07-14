import csv

fieldnames = ["Time", "lastUpdateId", "Mid-Price", "WM-Price", "CJP", 
    "alpha", "dataOLS"]

with open('data/data.csv', 'w') as csv_file:
    csv_writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
    csv_writer.writeheader()
    csv_file.close()
'''
fieldnames = ["test"]

with open('data/bar.csv', 'w') as csv_file:
    csv_writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
    csv_writer.writeheader()
    csv_file.close()

fieldnames = ["test0"]

with open('data/scatter.csv', 'w') as csv_file:
    csv_writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
    csv_writer.writeheader()
    csv_file.close()
'''

