import pandas as pd
from connection_config import connection_params
from functions import *
import mysql.connector
from mysql.connector import Error

''' Read the CSV file into a DataFrame '''
csv_file_path = '/Users/T1218/Desktop/Turing college/project2/FINAL_SPINNY_900.csv'
data = pd.read_csv(csv_file_path)
# print(data.columns)
# print(data.head(5))

''' Data preparation before creating tables'''
''' Change columns name: change commas to underscore and letters to lowercase '''
data.columns = data.columns.str.replace('(', '_').str.replace(')', '')
data.columns = data.columns.str.lower()

''' Call the function to find missing values '''
find_missing_values(data)

'''Call the function to find duplicates values'''
find_duplicates_values(data)

''' Keep first duplicate row '''
data1 = data.drop_duplicates( keep='first')
# print('After dropping duplicate rows:\n', data1)

'''Look into original data types'''
print('Data types of each column in the DataFrame:')
print(data1.dtypes)

''' Convert 'make_year' column to integer '''
convert_column_to_int(data1, 'make_year')

''' Convert 'mileage_run' column to float'''
convert_column_to_float(data1, 'mileage_run')
convert_column_to_float(data1, 'mileage_kmpl')

''' Convert 'price' column to float '''
convert_price_column(data1)

# print(data1.dtypes)


''' Convert DataFrame to list of tuples, replacing 'nan' with None '''
data_to_insert_tuples = [tuple(None if pd.isna(value) else value for value in row) for row in data1.itertuples(index=False)]

''' Unpack the connection parameters tuple '''
host, database, user, password = connection_params

''' Connect to MySQL '''
connection = mysql.connector.connect(
    host=host,
    user=user,
    password=password,
    database=database
)

try:
    if connection.is_connected():
        ''' Create a cursor '''
        cursor = connection.cursor()

        ''' Create a table'''
        create_table_query =''' 
            CREATE TABLE IF NOT EXISTS raw_data (
                car_name varchar (255),
                make varchar (255),
                model varchar (255),
                make_year integer,
                color varchar (255),
                body_type varchar (255),
                mileage_run float,
                no_of_owners varchar (255),
                seating_capacity integer,
                fuel_type varchar (255),
                fuel_tank_capacity_l integer,
                engine_type varchar (255),
                cc_displacement integer,
                transmission varchar (255),
                transmission_type varchar (255),
                power_bhp float,
                torque_nm float,
                mileage_kmpl float,
                emission varchar (255),
                price float)
        '''   

        cursor.execute(create_table_query)
        ''' Insert data into a MySQL table '''
        table_name = 'raw_data'
        
        ''' Insert data into the table '''
        insert_data_query = (
            f"INSERT INTO {table_name} (car_name, make, model, make_year, color, "
            f"body_type, mileage_run, no_of_owners, seating_capacity, fuel_type, "
            f"fuel_tank_capacity_l, engine_type, cc_displacement, transmission, "
            f"transmission_type, power_bhp, torque_nm, mileage_kmpl, emission, price) "
            f"VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, "
            f"%s, %s, %s, %s, %s)"
        )

        cursor.executemany(insert_data_query, data_to_insert_tuples)

        ''' Commit changes '''
        connection.commit()

        print("Table created and data inserted successfully.")
        print(f"{cursor.rowcount} rows inserted into {table_name}")
        
except Error as e:
    print(f"Error: {e}")
finally:
    ''' Close the cursor and the connection '''
    if connection.is_connected():
        cursor.close()
        connection.close()
        print("MySQL connection closed")