### Galaxy Seat Checker

This script will send an email when it sees that a class in your shopping cart as an open seat. 

##### Requirements

- Something that can run BASH
- Python (or whatever you want to send the email)
- Gmail account (if using my Python script)
- Crontab

##### Installation
```
git clone https://github.com/ke5gdb/GalaxySeatChecker.git
cd GalaxySeatChecker
touch user_id
```

In user_id, add two lines
```
USERID=(your netID)
PASS=(your netID password)
```

In send_txt.py, add this
```
#!/usr/bin/python

import smtplib
import sys 

text = str(sys.argv[1])

server = smtplib.SMTP("smtp.gmail.com", 587)
server.starttls()
server.login('GMAIL ACCOUNT', 'GMAIL PASS')
server.sendmail('GMAIL ACCOUNT', 'TO EMAIL ADDRESS', 'From: "GalaxySeatChecker" <GMAIL ACCOUNT>\r\nTo: TO EMAIL ADDRESS\r\n\r\n' + text)
server.close()
```

(PHONE NUMBER)@txt.att.net will send a text to your AT&T phone, if that's your carrier. 

Then 
```
chmod +x send_txt.py
```

The final installation step is to add it to your crontab. `*/5 * * * *` will run it every 5 minutes. 

##### What it does
1. The script logs into Galaxy using the credentials in user_id
2. It saves the cookies to cookies.txt; this contains the session information
3. It pulls your shopping cart, and saves the html file
4. With a series of greps and cuts, the script assembles an array of your classes
5. If the script sees that one of your classes is open, it sends the info to send_txt.py as an argument

###### It's very late and I'm very pissed at ECS Undergrad Advising. They're quite useless when you need to enroll in classes, and this is the only viable way I can enroll in one of my critical path classes this semester. 
