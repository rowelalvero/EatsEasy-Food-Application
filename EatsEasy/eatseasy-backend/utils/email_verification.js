const nodemailer = require('nodemailer');
const dotenv = require('dotenv').config();

async function sendVerificationEmail(userEmail, verificationCode) {
    const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.AUTH_USER,
            pass: process.env.AUTH_PASSWORD,
        }
    });

    const mailOptions = {
        from: process.env.AUTH_USER,
        to: userEmail,
        subject: 'EatsEasy Verification Code',
        html: `<h1>EatsEasy Email Verification</h1>
               <p>Your verification code is:</p>
               <h2 style="color: blue;">${verificationCode}</h2>
               <p>Please enter this code on the verification page to complete your registration process.</p>
               <p>If you did not request this, please ignore this email.</p>`
    };

    let retries = 3; // Number of retry attempts
    while (retries > 0) {
        try {
            await transporter.sendMail(mailOptions);
            console.log('Verification email sent successfully');
            return; // Exit once email is successfully sent
        } catch (error) {
            console.log('Email send failed with error:', error);
            retries -= 1;
            if (retries === 0) {
                console.log('Max retries reached. Failed to send email.');
            } else {
                console.log(`Retrying... Attempts left: ${retries}`);
            }
        }
    }
}

module.exports = sendVerificationEmail;
