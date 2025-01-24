const nodemailer = require('nodemailer');
const dotenv = require('dotenv').config();

async function approvedRequestEmail(userEmail, name, id, date, amount) {

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
        subject: "Your Payout Request Has Been Approved by EatsEasy",
        html: ` <h2>Congratulations! Your Request Has Been Approved</h2>

        <p>Dear ${name},</p>
    
        <p>We are thrilled to inform you that your recent payout request <strong>${id}</strong> of <strong>${amount} </strong> made on ${date} with EatsEasy has been approved! This marks a significant step, and we're excited to move forward with you.</p>
    
        <p>Should you have any questions or require further assistance, please feel free to reach out to our support team at eatseasy.services@gmail.com or +639294983155. We're here to support you every step of the way.</p>
    
        <p>Thank you for choosing EatsEasy. We look forward to continuing to work together.</p>
    
        <p>Best wishes,</p>
    
        <p>The EatsEasy Team</p>`

    };

    try {
        await transporter.sendMail(mailOptions);
        console.log("Approved request email sent successfully.");
    } catch (error) {
        console.log("Failed to send approved request email: ", error);
    }
}

module.exports = approvedRequestEmail;
