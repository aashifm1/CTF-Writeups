import requests
import base64
import re
import time

BASE = "http://15.206.47.5:9090"

session = requests.Session()

def solve_once():
    # Fetch task
    r = session.get(BASE + "/task")
    
    if r.status_code != 200:
        print("Failed to fetch /task")
        return None

    html = r.text
    print("\n[RAW TASK HTML]\n", html)

    # Finding a sequence of alphanumeric characters between 6 and 64 chars
    m = re.search(r'input string:\s*([A-Za-z0-9+/=]+)', html)
    if not m:
        print("Could not find task string")
        return None

    task = m.group(1)
    print("[*] Task extracted:", task)

    # Reverse
    rev = task[::-1]

    # Base64 encode
    b64 = base64.b64encode(rev.encode()).decode()

    # Wrap
    payload = f"CSK__{b64}__2025"
    print("[*] Payload:", payload)

    # Try raw text POST 
    resp = session.post(
        BASE + "/submit",
        data=payload,
        headers={"Content-Type": "text/plain"}
    )

    print("[*] Reply:", resp.text.strip())
    return resp.text.strip()


# Loop until success
while True:
    out = solve_once()
    if out and ("FLAG" in out.upper()):
        print("\n🎉 FLAG FOUND:", out)
        break
    time.sleep(0.02)
