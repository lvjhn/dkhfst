const nodemailer = require("nodemailer");
const fs = require("fs")

// SMTP transport configuration
const transporter = nodemailer.createTransport({
  host: "172.18.0.5",
  port: 1025,
  secure: false,       // true for STARTTLS/SMTPS
  tls: {
    rejectUnauthorized: false
  }
});

// Email details
const mailOptions = {
  from: "sender@example.com",
  to: "root@localhost.com",
  subject: "Test HTML Email from Node.js",
  text: "Hello, this is plain text.",
  html: "<h1>Hello!</h1><p>This is HTML content</p>"
};

// Send email
transporter.sendMail(mailOptions, (err, info) => {
  if (err) {
    console.error("Error sending email:", err);
  } else {
    console.log("Email sent:", info.response);
  }
});
