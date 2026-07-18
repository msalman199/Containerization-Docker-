#!/usr/bin/env python3

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
import time
import sys

def test_google_search():
    """Test Google search functionality"""
    
    # Configure Chrome options for Docker environment
    chrome_options = Options()
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--disable-gpu")
    
    # Connect to remote Selenium server
    try:
        driver = webdriver.Remote(
            command_executor='http://localhost:4444/wd/hub',
            options=chrome_options
        )
        
        print("✓ Successfully connected to Selenium container")
        
        # Navigate to Google
        driver.get("https://www.google.com")
        print("✓ Navigated to Google homepage")
        
        # Wait for search box to be present
        search_box = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.NAME, "q"))
        )
        
        # Perform search
        search_term = "Docker Selenium testing"
        search_box.send_keys(search_term)
        search_box.submit()
        
        print(f"✓ Searched for: {search_term}")
        
        # Wait for results to load
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.ID, "search"))
        )
        
        # Get page title
        page_title = driver.title
        print(f"✓ Page title: {page_title}")
        
        # Verify search results
        if search_term.lower() in page_title.lower():
            print("✓ Test PASSED: Search results displayed correctly")
            return True
        else:
            print("✗ Test FAILED: Search results not as expected")
            return False
            
    except Exception as e:
        print(f"✗ Test FAILED with error: {str(e)}")
        return False
        
    finally:
        # Clean up
        if 'driver' in locals():
            driver.quit()
            print("✓ Browser session closed")

def test_form_interaction():
    """Test form interaction on a demo website"""
    
    chrome_options = Options()
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--disable-gpu")
    
    try:
        driver = webdriver.Remote(
            command_executor='http://localhost:4444/wd/hub',
            options=chrome_options
        )
        
        print("\n--- Form Interaction Test ---")
        
        # Navigate to a demo form page
        driver.get("https://httpbin.org/forms/post")
        print("✓ Navigated to demo form page")
        
        # Fill out form fields
        customer_name = driver.find_element(By.NAME, "custname")
        customer_name.send_keys("John Doe")
        
        customer_tel = driver.find_element(By.NAME, "custtel")
        customer_tel.send_keys("555-1234")
        
        customer_email = driver.find_element(By.NAME, "custemail")
        customer_email.send_keys("john.doe@example.com")
        
        print("✓ Filled out form fields")
        
        # Submit form
        submit_button = driver.find_element(By.CSS_SELECTOR, "input[type='submit']")
        submit_button.click()
        
        print("✓ Form submitted successfully")
        
        # Wait for response page
        time.sleep(2)
        
        # Check if we got a response
        if "httpbin.org" in driver.current_url:
            print("✓ Form submission test PASSED")
            return True
        else:
            print("✗ Form submission test FAILED")
            return False
            
    except Exception as e:
        print(f"✗ Form test FAILED with error: {str(e)}")
        return False
        
    finally:
        if 'driver' in locals():
            driver.quit()
            print("✓ Browser session closed")

if __name__ == "__main__":
    print("Starting Selenium Docker Tests...")
    print("=" * 50)
    
    # Run tests
    test1_result = test_google_search()
    test2_result = test_form_interaction()
    
    # Summary
    print("\n" + "=" * 50)
    print("TEST SUMMARY:")
    print(f"Google Search Test: {'PASSED' if test1_result else 'FAILED'}")
    print(f"Form Interaction Test: {'PASSED' if test2_result else 'FAILED'}")
    
    if test1_result and test2_result:
        print("✓ All tests PASSED!")
        sys.exit(0)
    else:
        print("✗ Some tests FAILED!")
        sys.exit(1)
