import pandas as pd
from sqlalchemy import create_engine

def read_csv_to_df(file_path):
    """
    Reads a CSV file and returns a DataFrame.
    
    :param file_path: Path to the CSV file.
    :return: DataFrame containing the data from the CSV file.
    """
    return pd.read_csv(file_path)

def __main__(file_path, database_name, table_name):
    df = read_csv_to_df(file_path)
    engine = create_engine("mysql+mysqlconnector://root:root@localhost:3306/" + database_name)
    # Ensure the DataFrame is not empty before writing to SQL
    if df.empty:
        print("DataFrame is empty. No data to write to SQL.")
        return
    # Write the DataFrame to a SQL table
    df.to_sql(name=table_name, con=engine, if_exists="append", index=False)
