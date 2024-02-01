import pandas as pd
from typing import Optional

''' Check for missing values in the DataFrame '''
def find_missing_values(df: pd.DataFrame) -> Optional[str]:
    try:
        missing_values = df.isnull().sum()
        if any(missing_values):
            raise ValueError('Missing values found in the DataFrame')
        else:
            print('There are no missing values in the DataFrame.')
    except ValueError as error:
        print(f'Warning: {error}')


''' Find and return duplicate rows in the DataFrame '''
def find_duplicates_values(df: pd.DataFrame) -> pd.DataFrame:
    duplicates = df[df.duplicated(keep=False)]
    if not duplicates.empty:
        print('Warning: There are duplicate rows in the DataFrame.')
        print(duplicates)
    else:
        print("There are no duplicates in the DataFrame.")


''' Convert column to integer'''
def convert_column_to_int(df: pd.DataFrame, column_name: str) -> None:
    try:
        df.loc[:, column_name] = df.loc[:, column_name].astype(int)
    except ValueError:
        df.loc[:, column_name] = pd.to_numeric(df.loc[:, column_name], errors='coerce')
        df.loc[:, column_name] = df.loc[:, column_name].astype(int)


''' Convert column to float'''
def convert_column_to_float(df: pd.DataFrame, column_name: str) -> None:
    try:
        df.loc[:, column_name] = df.loc[:, column_name].astype(float) 
    except ValueError:
        try:
            ''' Handle non-numeric values (e.g., replace commas and retry) '''
            df.loc[:, column_name] = df.loc[:, column_name].str.replace(',', '').astype(float)
        except:
            ''' Additional handling if needed (e.g., apply other transformations) '''
            df.loc[:, column_name] = pd.to_numeric(df.loc[:, column_name], errors='coerce')
            df.loc[:, column_name] = df.loc[:, column_name].astype(float)


''' Convert price to integer'''
def convert_price_column(df: pd.DataFrame) -> None:
    ''' Change 'price' column to float '''
    try:
        df.loc[:, 'price'] = df.loc[:, 'price'].str.replace(',', '')
        ''' Remove commas in column and add a commas before two digits from the end '''
        df.loc[:, 'price'] = df.loc[:, 'price'].apply(lambda x: x[:-2] + '.' + x[-2:]).astype(float)
    except (ValueError, KeyError) as error:
        print(f"Error occurred while converting 'price' column: {error}")