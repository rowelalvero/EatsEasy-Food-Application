const nodemailer = require('nodemailer');
const dotenv = require('dotenv').config();

async function sendVerificationEmail(userEmail, name){

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
        subject: "EatsEasy Rider Verification",
        html: `<h2>Congratulations! Your EatsEasy Rider Has Been Verified</h2>

        <p>Dear ${name},</p>
    
        <p>We are thrilled to inform you that your driver account on EatsEasy has been successfully verified! Congratulations on completing the verification process.</p>
    
        <p>Restaurants can now discover your driver account with confidence, knowing that it has been verified by our team. This verification enhances your driver account's visibility and credibility on the EatsEasy platform.</p>
    
        <p>Thank you for choosing EatsEasy. We appreciate your commitment to providing accurate and up-to-date information for our users.</p>
    
        <p>If you have any questions or need further assistance, please don't hesitate to contact our support team at eatseasy.services@gmail.com or +639294983155.</p>
    
        <p>Best regards,</p>
    
        <p>Dre<br>
        The Creator<br>
        EatsEasy Support Team</p>`

    };

    try {
        await transporter.sendMail(mailOptions);
        console.log("Verification email sent");
    } catch (error) {
        console.log("Email sending failed with an error: ", error);
    }
}


module.exports = sendVerificationEmail;