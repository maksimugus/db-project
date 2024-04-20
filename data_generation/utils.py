import time

def run(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        
        # Execute execute_if_empty
        cursor, table_name, connection = args[:3]
        cursor.execute(f"SELECT * FROM {table_name} LIMIT 1")
        if cursor.fetchone():
            print(f"Data for table '{table_name}' is already generated.")
            return
        print(f"Generating data for table '{table_name}'.")
        
        # Execute run_query
        connection = args[2]
        try:
            result = func(*args, **kwargs)
            connection.commit()
        except Exception as e:
            print(str(e)[:100])

            connection.rollback()
            exit(1)
        
        # Execute timer
        end = time.time()
        print(f"Execution time: {end - start} s.")
        
        return result
    
    return wrapper
