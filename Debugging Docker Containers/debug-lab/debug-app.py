import time
import random
import sys

def problematic_function():
    # Simulate various issues
    issue = random.choice(['memory', 'exception', 'slow', 'success'])
    
    if issue == 'memory':
        print("WARNING: High memory usage detected")
        data = [0] * 1000000  # Allocate memory
        time.sleep(2)
    elif issue == 'exception':
        print("ERROR: About to raise an exception")
        raise Exception("Simulated application error")
    elif issue == 'slow':
        print("INFO: Processing slow operation")
        time.sleep(10)
    else:
        print("INFO: Operation completed successfully")

if __name__ == "__main__":
    print("Starting problematic application...")
    while True:
        try:
            problematic_function()
            time.sleep(3)
        except Exception as e:
            print(f"EXCEPTION: {e}")
            time.sleep(5)
