import csv
import sys
import argparse
from datetime import datetime

fieldnames = ["dataOLS"]

with open('data/data.csv', 'a') as csv_file:
    csv_writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

    info = {
        "Time": datetime.now(),
        "lastUpdateId": sys.argv[1],
        "Mid-Price": sys.argv[2],
        "WM-Price": sys.argv[3],
        "CJP": sys.argv[4],
        "alpha": sys.argv[5],
        "dataOLS": sys.argv[6]
    }

    csv_writer.writerow(info)
    print("lastUpdateId:" + info["lastUpdateId"])

#time.sleep(1)

# import datetime
# now = datetime.datetime.now()
# print(now.year, now.month, now.day, now.hour, now.minute, now.second)

import csv

fieldnames = ["Time", "lastUpdateId", "Mid-Price", "WM-Price", "CJP", 
    "alpha", "dataOLS"]

with open('data/data.csv', 'w') as csv_file:
    csv_writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
    csv_writer.writeheader()
    csv_file.close()