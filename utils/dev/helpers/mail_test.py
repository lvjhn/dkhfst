import smtplib
from email.mime.text import MIMEText
import sys

msg = MIMEText("Hello from Python test email")
msg["Subject"] = "Test Email"
msg["From"] = "sender@example.com"
msg["To"] = "recipient@example.com"

print("Sending message...")
with smtplib.SMTP(sys.argv[1], 1025) as server:
    server.send_message(msg)
    print("Message sent.")
