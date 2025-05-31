import pandas as pd
from sqlalchemy import create_engine
import mysql.connector

def read_csv(file_path: str, delimiter: str = ';') -> pd.DataFrame:
    try:
        return pd.read_csv(file_path, delimiter=delimiter, encoding='utf-8')
    except Exception as e:
        raise RuntimeError(f"Falha ao ler CSV: {e}")

def read_json(file_path: str) -> pd.DataFrame:
    try:
        data = pd.read_json(file_path, encoding='utf-8')
        return data
    except Exception:
        raise RuntimeError(f"Falha ao ler JSON: {file_path}")

def read_mysql(source_cfg: dict, table: str) -> pd.DataFrame:
    url = (f"mysql+mysqlconnector://{source_cfg['user']}:{source_cfg['password']}@"
            f"{source_cfg['host']}:{source_cfg.get('port',3306)}/{source_cfg['database']}")
    engine = create_engine(url, echo=False)
    return pd.read_sql(f"SELECT * FROM {table}", engine)

