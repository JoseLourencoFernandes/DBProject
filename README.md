# Prestige Limousines - Relational Database Project

**University of Minho**
**Database Systems Course**
**Academic Year:** 2024/2025

## Project Description

This project involves the design and implementation of a **relational database** for an emerging limousine company: **Prestige Limousines**.

As part of the development, we also implemented a **data migration system** that supports importing data either from formatted files or from another relational database.

## Features

* Full Relational Database System Development:

  * System Definition and Requirement Gathering
  * Conceptual Modeling
  * Logical Modeling
  * Physical Implementation

* Relational Database schema for Prestige Limousines
* Data migration system with support for:

  * CSV files
  * JSON files
  * Migration between two databases

## Migration Instructions

### Activate Migration Virtual Environment

```bash
$ source migration/bin/activate
```

### Deactivate Migration Virtual Environment

```bash
$ deactivate
```

### Folder: `migration_data`

Contains:

* Python scripts (`.py`)
* Shell script (`migrate.sh`)

### Running the Python Script

**With Destination Database & File (CSV/JSON):**

```bash
python3 migrar.py --dest <IP>:<PORT>:<USER>:<PASS>:<DB_NAME> file <file.csv/json> <TABLE_NAME>
```

*Example:*

```bash
python3 migrar.py --dest 127.0.0.1:3306:root:root:PrestigeLimousines file clientes.csv Cliente
```

**With Destination and Source Databases:**

```bash
python3 migrar.py --dest <DEST_IP>:<PORT>:<USER>:<PASS>:<DB_NAME> table <SOURCE_IP>:<PORT>:<USER>:<PASS>:<DB_NAME> <TABLE_NAME>
```

*Example:*

```bash
python3 migrar.py --dest 127.0.0.1:3306:root:root:PrestigeLimousines table 127.0.0.1:3306:root:root:PrestigeLimousines2 Cliente
```

### Running the Shell Script

**With Files (CSV or JSON):**

```bash
./migrate.sh <csv/json> <DB_NAME>
```

*Example:*

```bash
./migrate.sh csv PrestigeLimousines
```

**With Two Active Databases:**

```bash
./migrate.sh sql <DEST_DB> <SOURCE_DB>
```

*Example:*

```bash
./migrate.sh sql PrestigeLimousines2 PrestigeLimousines
```

---

## Grade

**⭐ Grade: X / 20 ⭐**

---

## Authors

- *Daniel Parente* -> [@parente33](https://github.com/parente33)
- *Gabriel Dantas* -> [@gabil88](https://github.com/gabil88)
- *José Fernandes* -> [@JoseLourencoFernandes](https://github.com/JoseLourencoFernandes)
- *Simão Oliveira* -> [@SimaoOliveira05](https://github.com/SimaoOliveira05)

---
