def run_query(sql, conn):
    """
    Run a query, and return its results.

    :param sql: The query to the execute.
    :type sql: str
    :param conn: The connection to the database where query will be executed.
    :type conn: sqlite3.Connection
    """
    print(f"Running SQL:\n{sql}")
    with conn:
        cursor = conn.execute(sql)
        return cursor.fetchall()

def create_table(conn, table_name, table_schema):
    """
    Create a table, if it doesn't already exist.

    :param conn: A connection to a database, for executing queries.
    :type conn: sqlite3.Connection
    """
    sql = f"CREATE TABLE IF NOT EXISTS {table_name} ("
    for column_name, column_details in table_schema.items():
        column_type = column_details["type"]
        sql += f"\r\n\t{column_name} {column_type},"
    # remove last comma and add closing parenthesis
    sql = sql[:-1] + "\r\n);"
    print(f"Creating table {table_name}")
    results = run_query(sql, conn)
    return results

def copy_into_table(conn, data, table_name, table_schema):
    """
    Add new rows to this table.

    :param conn: A connection to a database, for executing queries.
    :type conn: sqlite3.Connection
    :param data: Rows being added to this table.
    :type data: List[Tup]
    """
    column_count = len(table_schema.keys())
    entry = "?," * (column_count - 1) + "?"
    sql = f"INSERT INTO {table_name} VALUES ({entry})"
    # print(f"Adding new rows to table {table_name}")
    # print(sql)
    with conn: 
        cursor = conn.executemany(sql, data)
        return cursor.fetchall()
