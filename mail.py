import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# SMTP configuration
SMTP_HOST = "postfix.dkhfst-app.test"   # Postfix or Mailpit hostname
SMTP_PORT = 25         # Mailpit default port
USE_TLS   = True          # Dev: set False to avoid self-signed cert issues

# Create multipart message
msg = MIMEMultipart("alternative")
msg["From"] = "sender@example.com"
msg["To"] = "test@example.com"
msg["Subject"] = "Test HTML Email from Python"

# Plain text part
text = "Hello, this is plain text."
# HTML part
html = "<html><body><h1>Hello!</h1><p>This is HTML content</p></body></html>"

msg.attach(MIMEText(text, "plain"))
msg.attach(MIMEText(html, "html"))

# Send email
try:
    if USE_TLS:
        with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
            server.starttls()  # optional: use TLS
            server.send_message(msg)
    else:
        with smtplib.SMTP(SMTP_HOST, SMTP_PORT) as server:
            server.send_message(msg)

    print("Email sent successfully!")
except Exception as e:
    print("Error sending email:", e)
