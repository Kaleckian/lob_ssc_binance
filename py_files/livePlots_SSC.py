# %%
from itertools import count
from datetime import datetime

import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

plt.style.use('fivethirtyeight')

index = count()
# %%
def animate(i):
# %%
    data = pd.read_csv('data/data.csv').drop_duplicates(
        subset=['lastUpdateId'], keep = "first").tail(1)

    data['Time'] = data['Time'].apply(
        lambda x: datetime.strptime(x, '%Y-%m-%d %H:%M:%S.%f')
    )

    if True:
        data = data.tail(1)

# %%
    fig, ax = plt.subplots()

    ax.set_title(f"Last update: {t} (ID: {data['Time']})")

    sns.scatterplot(x="price", y="quantity", hue="side", data=data, ax=ax)

    ax.set_xlabel("Price")
    ax.set_ylabel("Quantity")

    x =  data['Time'].apply(lambda x: x.strftime("%H:%M:%S.%f")[:-3])
    y4 = data['alpha'].apply(lambda x: x*100)

    list_tup = data['Time']

    plt.cla()

    plt.plot(x, y4, label='Alpha Parameter (Liquidity)')

    plt.xlabel('Time')
    plt.xticks(fontsize=10, rotation=90)

    plt.title('BTCUSDT - Alpha')

    plt.legend(loc='lower left', fontsize = 10)
    plt.tight_layout()

ani = FuncAnimation(plt.gcf(), animate, interval=0)

plt.tight_layout()
plt.show()
