import pandas as pd
import numpy as np

def clean_fraud_data(input_file='raw_transaction_data.csv', output_file='cleaned_transaction_data.csv'):
    print("Loading 5 million rows... (This might take 30-60 seconds depending on your RAM)")
    
    # Load the data
    df = pd.read_csv(input_file)
    initial_rows = len(df)
    print(f"Successfully loaded {initial_rows} rows.")

    print("\n--- Starting Cleaning Process ---")

    # 1. DEDUPLICATION
    # Drop rows that have the exact same transaction_id
    df = df.drop_duplicates(subset=['transaction_id'], keep='first')
    print(f"Dropped {initial_rows - len(df)} duplicate transactions.")

    # 2. STANDARDIZATION
    # Fix the inconsistent casing in location_city (e.g., 'vadodara', 'VADODARA' -> 'Vadodara')
    df['location_city'] = df['location_city'].str.title()
    print("Standardized location city names.")

    # 3. HANDLING MISSING VALUES (IMPUTATION)
    # Fill blank merchant categories and payment methods with 'Unknown'
    missing_merchants = df['merchant_category'].isna().sum()
    missing_payments = df['payment_method'].isna().sum()
    
    df['merchant_category'] = df['merchant_category'].fillna('Unknown')
    df['payment_method'] = df['payment_method'].fillna('Unknown')
    print(f"Imputed {missing_merchants} missing merchants and {missing_payments} missing payment methods.")

    # 4. FIXING IMPOSSIBLE DATA (Errors & Outliers)
    # Fix negative transaction amounts by converting them to absolute (positive) values
    negative_amounts = (df['amount'] < 0).sum()
    df['amount'] = df['amount'].abs()
    print(f"Corrected {negative_amounts} negative transaction amounts.")

    # Fix corrupted dates. 'coerce' turns invalid strings into NaT (Not a Time)
    print("Parsing timestamps and removing corrupted dates...")
    df['timestamp'] = pd.to_datetime(df['timestamp'], errors='coerce')
    
    # Drop the rows where the timestamp was completely corrupted (NaT)
    corrupted_dates = df['timestamp'].isna().sum()
    df = df.dropna(subset=['timestamp'])
    print(f"Removed {corrupted_dates} rows with corrupted, unreadable timestamps.")

    # Sort the dataset chronologically so our future time-based analysis works properly
    df = df.sort_values(by=['customer_id', 'timestamp']).reset_index(drop=True)

    print("\n--- Cleaning Complete ---")
    final_rows = len(df)
    print(f"Final dataset contains {final_rows} clean rows.")
    
    # Save the cleaned data
    print(f"Saving to {output_file}...")
    df.to_csv(output_file, index=False)
    print("Success! Dataset is ready for Feature Engineering.")

# Run the cleaning function
if __name__ == "__main__":
    clean_fraud_data()