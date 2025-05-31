def parse_db_config(cfg: str) -> dict:
    parts = cfg.split(':')
    if len(parts) != 5:
        raise ValueError("Use host:port:user:password:database")
    host, port, user, pwd, db = parts
    return {'host': host, 'port': int(port), 'user': user, 'password': pwd, 'database': db}

