import sys
import requests

def login(password):
    url = 'http://10.3.50.1/login'
    headers = {
        'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Connection': 'keep-alive',
        'Origin': 'http://10.3.50.1',
    }
    data = {
        'username': 'foo',
        'password': password,
        'dst': '',
        'popup': 'true'
    }
    
    cookies = {
        'paswd': password,
        'uname': 'foo',
        'error': '1'
    }
    
    response = requests.post(url, headers=headers, data=data, cookies=cookies)
    
    # Checking the response status and printing it
    if response.status_code == 200:
        print(f"Login successful! Response: {response.status_code}")
    else:
        print(f"Failed to log in. Status code: {response.status_code}")

if __name__ == '__main__':
    if len(sys.argv) < 1:
        print("Please provide password as command line arguments.")
        sys.exit(1)
    
    password = sys.argv[1]
    login(password)

