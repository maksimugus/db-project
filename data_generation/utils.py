import time
import sys

def run(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        
        # Execute execute_if_empty
        cur, table, conn = args[:3]
        cur.execute(f"SELECT id FROM {table} LIMIT 1")
        if cur.fetchone():
            print(f"{table.capitalize()} already generated")
            return
        print(f"Generating {table}")
        
        # Execute run_query
        conn = args[2]
        try:
            result = func(*args, **kwargs)
            conn.commit()
        except Exception as e:
            print(e)
            conn.rollback()
            sys.exit(1)
        
        # Execute timer
        end = time.time()
        print(f"Execution time: {end - start}")
        
        return result
    
    return wrapper
