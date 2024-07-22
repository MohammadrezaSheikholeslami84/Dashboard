# MQL4 Dashboard

## Overview

Dashboard.mq4 is a MetaTrader 4 (MT4) indicator designed to monitor and display trading performance in real time. It provides a graphical dashboard on the MT4 chart, showing various statistics such as total lots, profit, and loss for different symbols. Additionally, it includes features for alerting when profits exceed a specified threshold and for managing trades directly from the chart.

## Features

- **Real-time Monitoring**: Continuously updates and displays trading performance metrics.
- **Profit Alarming**: Sends notifications and alerts when profits exceed a predefined threshold.
- **Interactive Chart Elements**: Allows users to open symbol charts and close all positions for a symbol directly from the chart.
- **Customizable Labels and Buttons**: Displays lots and profit/loss information with customizable UI elements.

## Installation

1. Copy `Dashboard.mq4` to your MT4 indicators directory:
   ```
   <Your MT4 Directory>/MQL4/Indicators/
   ```
2. Restart your MT4 terminal or refresh the indicators list.
3. Attach the `Dashboard` indicator to the desired chart.

## Input Parameters

- **AlarmNotification** (`bool`): Enable or disable profit alarm notifications.
- **ProfittoAlarm** (`double`): Profit threshold for triggering alarms.
- **Delay** (`int`): Delay in minutes for checking the profit alarm condition.

## How to Use

1. **Attach the Indicator**: Add the `Dashboard` indicator to any chart where you want to monitor trading performance.
2. **Configure Parameters**: Adjust the input parameters (if necessary) according to your needs.
3. **Monitor Performance**: The indicator will directly display metrics such as total lots, profit, and loss on the chart.
4. **Interactive Features**:
   - Click on the buttons corresponding to symbols to open their charts or to close all positions for that symbol.


## Example Usage

1. **Setting Up Profit Alarm**:
   - Set `AlarmNotification` to `true`.
   - Define `ProfittoAlarm` as the desired profit threshold (e.g., 350).

2. **Monitoring Performance**:
   - Attach the indicator and observe the real-time updates on the chart.
   - Click on the buttons to manage trades directly from the chart interface.

## Contact

- **Developer**: MohammadReza Sheikholeslami
- **Phone / WhatsApp / Telegram**: +98 920 322 8135

For further assistance or inquiries, please get in touch with the developer using the provided contact information.


## Demo
![image](https://github.com/user-attachments/assets/f32e8eff-226e-4b6f-8ca2-0a0fa29d58cd)
