import streamlit as st
from stock3 import fetch_data, analyze_trend
import matplotlib.pyplot as plt

st.title("📈 Stock Trend Analyzer")

ticker = st.text_input("Enter stock ticker (e.g., AAPL)").upper().strip()

if ticker:
    df = fetch_data(ticker)
    if df is not None:
        current_price = df['Close'].iloc[-1]
        st.write(f"Current price for **{ticker}**: ${current_price:.2f}")

        trend_message, alert, _ = analyze_trend(df)
        st.subheader("Trend Analysis Result")
        st.write(trend_message)
        if alert:
            st.warning(alert)

        fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8), sharex=True)

        ax1.plot(df.index, df['Close'], label='Close Price', color='blue')
        ax1.plot(df.index, df['Close'].rolling(5).mean(), label='5-Day MA', linestyle='--', color='orange')
        ax1.set_title(f"{ticker} - Closing Prices")
        ax1.set_ylabel("Price")
        ax1.grid(True)
        ax1.legend()

        ax2.bar(df.index, df['Volume'], color='grey', alpha=0.6, label='Volume')
        ax2.plot(df.index, df['Volume'].rolling(5).mean(), label='5-Day MA Volume', color='red')
        ax2.set_title(f"{ticker} - Volume")
        ax2.set_ylabel("Volume")
        ax2.grid(True)
        ax2.legend()

        fig.autofmt_xdate()
        st.pyplot(fig)
