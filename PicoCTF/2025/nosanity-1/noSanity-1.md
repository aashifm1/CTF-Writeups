# n0s4n1ty 1

> A developer has added profile picture upload functionality to a website. 
> However, the implementation is flawed, and it presents an opportunity for you. 
> Your mission, should you choose to accept it, is to navigate to the provided web page and locate the file upload area. 
> Your ultimate goal is to find the hidden flag located in the /root directory.

## Observation

1. Notice, there was Apache server running.

2. Testing simple .php file (which worked). Sometime need to change to .png (extension check), or .png + "89 50 4E 47" (extension check and Image Bits in file) + .htaccess will solve the lab.

> Once you get into the server, look for "what permission you have?".

## Steps to solve

1. Need a PHP reverse webshell - [Get it Here](https://github.com/aashifm1/php-webshell).

2. Upload the webshell.php in the profile upload functionality.

3. Once the file is uploaded, it says the file is stored in /uploads/webshell.php.

4. Open the webshell file path - https://target.com/uploads/webshell.php

5. That's a success, it is a file upload vulnerability.

6. Execute the shell commands - `sudo -l`.

```bash
Matching Defaults entries for www-data on challenge:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User www-data may run the following commands on challenge:
    (ALL) NOPASSWD: ALL
```

7. That's a success, it is a remote code execution.

8. Use this below command.

```bash
-$ sudo /bin/bash -c 'whoami'
root

-$ sudo /bin/bash -c 'cat /root/*'
picoCTF{flag}
```

### Flag found...
