const nodemailer = require("nodemailer");
const fs = require("fs")

// SMTP transport configuration
const transporter = nodemailer.createTransport({
  host: "mail.dkhfst-app.stage",
  port: 465,
  auth: {
    user: "user@example.com",
    pass: "password"
  },  
  secure: true,       // true for STARTTLS/SMTPS
  tls: {
    rejectUnauthorized: false
  }
});

// Email details
const mailOptions = {
  from: "sender@example.com",
  to: "root@example.com",
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
