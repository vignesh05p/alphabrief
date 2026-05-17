At user level, **AlphaBrief works like this**:

## AlphaBrief — User-Level Workflow

### 1. User signs up

User opens AlphaBrief and creates an account using email and password.

```text
User → AlphaBrief account created
```

---

### 2. User connects Zerodha Kite

User clicks **Connect Zerodha Kite**.

AlphaBrief redirects the user to Zerodha login. After login, Zerodha gives permission to AlphaBrief to read portfolio data.

```text
User → Login with Zerodha → Permission granted → AlphaBrief connected
```

AlphaBrief should only read portfolio/holdings data. It should **not place trades**.

---

### 3. AlphaBrief fetches portfolio

After connection, AlphaBrief reads the user’s current portfolio:

```text
Stocks owned
Quantity
Average buy price
Current price
Profit/loss
Total portfolio value
```

Example:

```text
TCS: 5 shares
Buy price: ₹3,500
Current price: ₹3,700
Profit: ₹1,000
```

---

### 4. AlphaBrief saves weekly snapshot

Every week, AlphaBrief stores the portfolio status.

This is important because without old data, the app cannot compare performance.

```text
Last week portfolio value: ₹1,00,000
This week portfolio value: ₹1,05,000
Weekly profit: ₹5,000
Weekly return: 5%
```

---

### 5. AlphaBrief analyzes performance

The system calculates:

```text
Total profit/loss
Weekly return
Top performing stocks
Worst performing stocks
Portfolio allocation
Risk concentration
Benchmark comparison with Nifty 50
```

Example:

```text
Your portfolio increased by 3.2% this week.
Nifty 50 increased by 1.1%.
Your portfolio outperformed Nifty by 2.1%.
```

---

### 6. AlphaBrief generates PDF report

At the end of the week, AlphaBrief creates a clean PDF.

The PDF contains:

```text
Portfolio summary
Weekly performance
Top gainers
Top losers
Stock allocation
Risk notes
Benchmark comparison
Simple explanation
```

Example PDF heading:

```text
AlphaBrief Weekly Portfolio Report
Week: 10 June – 16 June
Portfolio Value: ₹1,24,500
Weekly Gain: ₹4,200
Weekly Return: 3.49%
```

---

### 7. User receives report

User receives the report through:

```text
Email
WhatsApp later
```

MVP should do **email first**. WhatsApp can be added later.

```text
Every Saturday/Sunday → AlphaBrief sends weekly PDF report
```

---

### 8. User opens dashboard

User can also login to AlphaBrief dashboard and see:

```text
Current portfolio value
Holdings table
Weekly performance chart
Old reports
Kite connection status
Manual generate report button
```

---

## Simple real-life example

You invest in Zerodha but you are busy during the week.

Instead of opening Kite daily, AlphaBrief automatically checks your portfolio every week and sends:

```text
“This week your portfolio gained ₹3,800.
Best stock: Tata Motors +8%.
Worst stock: Infosys -2%.
Your portfolio beat Nifty 50 by 1.5%.
PDF report attached.”
```

That is the whole idea.

## One-line explanation

```text
AlphaBrief connects to Zerodha Kite, reads your portfolio, tracks weekly performance, creates a PDF report, and sends it to you automatically.
```

Do not overcomplicate the user story. The user problem is simple: **“I don’t have time to review my portfolio, so send me a weekly portfolio intelligence report.”**
