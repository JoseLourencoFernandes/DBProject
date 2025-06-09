from sqlalchemy import create_engine, text

def write_to_mysql(df, table: str, dest_cfg: dict) -> None:
    url = (f"mysql+mysqlconnector://{dest_cfg['user']}:{dest_cfg['password']}@"
            f"{dest_cfg['host']}:{dest_cfg.get('port',3306)}/{dest_cfg['database']}")
    engine = create_engine(url, echo=False)
    with engine.begin() as conn:
        df.to_sql(name=table, con=conn, if_exists="append", index=False, method="multi")
        count = conn.execute(text(f"SELECT COUNT(*) FROM {table}")).scalar()
    print(f"{len(df)} registros migrados para {table} (total agora: {count})")
    
