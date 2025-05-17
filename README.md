# Synthetic Financial Data Generation

This project simulates synthetic population data, banking entities, and realistic financial transactions over time. It consists of three main components:

1. [People Generation](#1-people-generation)
2. [Banks, Companies, and People Integration](#2-banks-companies-and-people-integration)
3. [Transaction Generation](#3-transaction-generation)

---

## 1. People Generation

This component generates a synthetic population using a combination of assumptions and predictive models trained on a base dataset.

### Steps

1. **Country Selection**  
   Based on assumed birth rates. Includes 27 EU countries.

2. **Gender Assignment**  
   Based on the male-to-female ratio in the selected country.

3. **Age Sampling**  
   Sampled from a normal distribution:
   - **Mean**: average age of that gender in that country
   - **Standard deviation**: 20% of the mean

4. **Education Level (`m1`)**  
   Predicted using `age`, `gender`, and `country`.

5. **Education Title (`m2`)**  
   Randomly assigned (due to lack of training data), based on the education level.

6. **Profession (`m3`)**  
   Randomly assigned based on the education title.

7. **Years of Experience (`m4`)**  
   Predicted using `age`, `gender`, `country`, and `profession`.

8. **Working Status (`m5`)**  
   Predicted using `age`, `gender`, `country`, `profession`, and `years of experience`.

9. **Salary (`m6`)**  
   - If working: predicted using `gender`, `country`, `profession`, and `years of experience`.
   - If not working: assumed to receive social benefits (minimum cost of living in that country).

10. **Initial Balance (`m7`)**  
    Predicted using `gender`, `country`, `education level`, `profession`, `years of experience`, and `working status`.

### Output

Running the `people` notebook will generate a `people` DataFrame.

To create a custom version:
- Train models using your own dataset.
- Integrate them into the `people` notebook.

> Current models are built in **R** and predictions are retrieved via the `api.R` file.

---

## 2. Banks, Companies, and People Integration

You can modify the `companies`, `banks`, or `people` DataFrames as needed. When adding new entities, leave the following fields empty:
- `IDN`
- `IBAN`
- `account_nr`

### Syncing Entities

After modifications:
- Run the `banks_companies_people_sync` notebook.
- This will assign unique `IDNs` and `bank accounts` to all people, companies, and banks.
- The mapping will be stored in the `bank_acc_ids` DataFrame.

---

## 3. Transaction Generation

### Required Inputs

Ensure the following DataFrames are ready:

- **`moments`**  
  Created using the `moments` notebook. Define:
  - Number of transactions
  - Time period  
  You can assign weights to specific years, months, days, or hours to control transaction distribution.

  **Output Columns:**
  - `moment`: timestamp of the transaction
  - `type`: either `monthly` or `other`
    - `monthly`: triggers monthly expenses for all individuals
    - `other`: triggers individual-based transaction generation

- **`categories_weights`**  
  Contains category weights for each hour, influencing transaction category selection.  
  Generated from `categories_weights_reference` using the `categories_weights` notebook.

- **`people`, `banks`, `companies`, `bank_acc_ids`**  
  Must be prepared and synchronized.

- **`categories_mean_costs_per_country`**  
  Contains average category costs per country. Used to calculate transaction amounts.  
  This file is editable for realism.

---

### Transaction Logic

For each row in the `moments` DataFrame:

- **If `type = monthly`:**
  - Recurring transactions (e.g. rent, salary, internet) are executed for all individuals.

- **If `type = other`:**
  1. Randomly select a person.
  2. Choose a category based on:
     - Hourly category weights.
     - Individual purchase history (e.g. coffee buyers are likely to buy coffee again).
  3. Determine amount:
     - Sample from a normal distribution around the mean cost of that category in the individual’s country.
  4. Determine destination:
     - For regular categories: randomly select a company in the same country.
     - For category "tekkie": randomly select another person from the same country.

---

## Quick Start Guide

### 1. Prepare Companies
- Add/edit companies as needed.
- Leave `IDN`, `IBAN`, and `account_nr` fields blank.

### 2. Prepare Banks
- Add/edit banks similarly.
- Leave `IDN`, `IBAN`, `account_nr`, and `balance` fields blank.

### 3. Generate People
- You can either use our generated sample of 3000 people, or if you want to generate your own, follow these steps:
  - Create a realistic DataFrame to use as a training dataset.
  - Train your models.
  - Edit the code in the `people` notebook accordingly (e.g., if you're using R, ensure that your trained R models return correct responses within the notebook).
  - Ensure all professions in `ai_training_df` exist in `professions.xlsx`.
  - Run the `people` notebook with your newly updated models.



### 4. Generate Moments
- Use the `moments` notebook.
- Define the total number of transactions and date range.

### 5. Prepare Categories Weights
- Modify the `categories_weights_reference` DataFrame.
- Run the `categories_weights` notebook to generate the final `categories_weights` DataFrame.

> You can include weights for any date, even future years. If the date is outside the range defined in `moments`, it will be ignored.

### 6. Generate Transactions
- Run the `transactions` notebook to generate synthetic transaction data.

---

## Notes

- All data used for model training, assumptions, and editing can be found in the relevant notebooks and datasets.
- You are encouraged to customize weights, costs, and training data to suit your specific use case.

---

Happy simulating! :) 
