
from itertools import count
from datetime import datetime

import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

plt.style.use('fivethirtyeight')

x_vals = []
y_vals = []

index = count()


def animate(i):
    data = pd.read_csv('data/data.csv').drop_duplicates(
        subset=['lastUpdateId'], keep = "first")

    x =  data['Time'].apply(lambda x: x.strftime("%H:%M:%S"))
    y1 = data['Mid-Price']
    y2 = data['CJP']

    plt.cla()

    plt.plot(x, y1, label='Mid-Price')
    plt.plot(x, y2, label='CJP Mtgl.')
    plt.xticks(rotation=90)

    plt.legend(loc='upper left')
    plt.tight_layout()

ani = FuncAnimation(plt.gcf(), animate, interval=500)

plt.tight_layout()
plt.show()
