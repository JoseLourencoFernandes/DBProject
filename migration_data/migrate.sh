#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
    echo "Uso: $0 <mode> <dest_db> [src_db]"
    echo "  mode    → json, csv, ou sql"
    echo "  dest_db → base de dados destino"
    echo "  src_db  → base de dados origem (apenas para modo sql)"
    echo ""
    echo "Exemplos:"
    echo "  $0 json PrestigeLimousines"
    echo "  $0 csv PrestigeLimousines"
    echo "  $0 sql PrestigeLimousines PrestigeLimousines2"
    exit 1
fi

MODE=$1
DEST_DB=$2
SRC_DB=${3:-}

# Validação para modo sql
if [[ "$MODE" == "sql" && -z "$SRC_DB" ]]; then
    echo "Erro: modo 'sql' requer base de dados origem" >&2
    echo "Uso: $0 sql <dest_db> <src_db>" >&2
    exit 1
fi

echo "Starting migration script (mode=$MODE, dest=$DEST_DB)..."

# Configuração de conexão (você pode modificar host, porta, user, pass)
HOST="127.0.0.1"
PORT="3306"
USER="root"
PASS="root"

case "$MODE" in
    json)
    echo "→ migrando apenas JSONs para $DEST_DB"
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB file stands.json Stand
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB file clientes.json Cliente
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB file funcionarios.json Funcionario
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB file limousines.json Limousine
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB file alugueres.json Aluguer
    ;;

    csv)
    echo "→ migrando apenas CSVs para $DEST_DB"
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB file stands.csv Stand
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB file clientes.csv Cliente
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB file funcionarios.csv Funcionario
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB file limousines.csv Limousine
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB file alugueres.csv Aluguer
    ;;

    sql)
    echo "→ migrando tabelas de $SRC_DB para $DEST_DB"
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB table $HOST:$PORT:$USER:$PASS:$SRC_DB Stand
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB table $HOST:$PORT:$USER:$PASS:$SRC_DB Cliente
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB table $HOST:$PORT:$USER:$PASS:$SRC_DB Funcionario
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB table $HOST:$PORT:$USER:$PASS:$SRC_DB Limousine
    python3 migrar.py --dest $HOST:$PORT:$USER:$PASS:$DEST_DB table $HOST:$PORT:$USER:$PASS:$SRC_DB Aluguer
    ;;

  *)
    echo "Modo desconhecido: $MODE" >&2
    exit 1
    ;;
esac

echo "Migração concluída!"

