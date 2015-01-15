### Galaxy Seat Checker

This script will send an email when it sees that a class in your shopping cart as an open seat. 

##### Requirements

- Something that can run BASH
- Python (or whatever you want to send the email)
- Gmail account (if using my Python script)
- Crontab

##### Installation
> git clone https://github.com/ke5gdb/GalaxySeatChecker.git
> cd GalaxySeatChecker
> touch user_id

In user_id, add two lines
> USERID=(your netID)
> PASS=(your netID password)

In send_txt.py, add this
> #!/usr/bin/python
>
> import smtplib
> import sys 
>
> text = str(sys.argv[1])
>
> server = smtplib.SMTP("smtp.gmail.com", 587)
> server.starttls()
> server.login('GMAIL ACCOUNT', 'GMAIL PASS')
> server.sendmail('GMAIL ACCOUNT', 'TO EMAIL ADDRESS', 'From: "GalaxySeatChecker" <GMAIL ACCOUNT>\r\nTo: TO EMAIL ADDRESS\r\n\r\n' + text)
> server.close()

Then 
> chmod +x send_txt.py
