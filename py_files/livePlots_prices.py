from itertools import count
from datetime import datetime

import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

plt.style.use('fivethirtyeight')

index = count()

def animate(i):
    data = pd.read_csv('data/data.csv').drop_duplicates(
        subset=['lastUpdateId'], keep = "first")

    if data.shape[0] >= 30:
        data = data.tail(30)

    data['Time'] = data['Time'].apply(
        lambda x: datetime.strptime(x, '%Y-%m-%d %H:%M:%S.%f')
    )

    x =  data['Time'].apply(lambda x: x.strftime("%H:%M:%S.%f")[:-3])
    y1 = data['Mid-Price'].apply(lambda x: round(x/1000, 2))
    y2 = data['CJP'].apply(lambda x: round(x/1000, 2))
    y3 = data['bestBid'].apply(lambda x: round(x/1000, 2))
    y4 = data['bestAsk'].apply(lambda x: round(x/1000, 2))
    
    list_tup = data['Time'][:-1]

    plt.cla()

    plt.plot(x, y1, label='Weighted-Price')
    plt.plot(x, y2, label='CJP Mtgl.')
    plt.plot(x, y3, label='Best Bid')
    plt.plot(x, y4, label='Best Ask')

    plt.xlabel('Time')
    plt.xticks(fontsize=10, rotation=90)

    plt.title('BTCUSDT - USD K')

    plt.legend(loc='lower left', fontsize = 10)
    plt.tight_layout()

ani = FuncAnimation(plt.gcf(), animate, interval=0)

plt.tight_layout()
plt.show()


