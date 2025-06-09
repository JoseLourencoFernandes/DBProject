import argparse, sys
from readers import read_csv, read_json, read_mysql
from writers import write_to_mysql
from config import parse_db_config

def main():
    parser = argparse.ArgumentParser(description="Migração CSV/JSON/MySQL → MySQL")
    parser.add_argument("--dest", required=True,
                        help="destino host:port:user:pass:database")
    sub = parser.add_subparsers(dest="cmd", required=True)

    # subcomando 'file'
    f = sub.add_parser("file", help="migrar CSV/JSON")
    f.add_argument("src", help="arquivo .csv ou .json")
    f.add_argument("table", help="tabela destino")

    # subcomando 'table'
    t = sub.add_parser("table", help="migrar tabela de MySQL")
    t.add_argument("src_cfg", help="origem host:port:user:pass:database")
    t.add_argument("table", help="tabela para copiar")

    args = parser.parse_args()
    try:
        dest_cfg = parse_db_config(args.dest)
    except ValueError as e:
        print(f"Dest config inválida: {e}"); sys.exit(1)

    if args.cmd == "file":
        reader = read_csv if args.src.lower().endswith(".csv") else read_json
        df = reader(args.src)
        write_to_mysql(df, args.table, dest_cfg)

    elif args.cmd == "table":
        src_cfg = parse_db_config(args.src_cfg)
        df = read_mysql(src_cfg, args.table)
        write_to_mysql(df, args.table, dest_cfg)

if __name__ == "__main__":
    main()
    
    