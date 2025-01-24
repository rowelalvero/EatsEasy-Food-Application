const nodemailer = require('nodemailer');
const dotenv = require('dotenv').config();


async function rejectionDriverEmail(userEmail, name){

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
        html: ` <h2>EatsEasy Rider Verification Rejected</h2>

        <p>Dear ${name},</p>
    
        <p>We regret to inform you that the verification process for your driver account on EatsEasy has been rejected. We appreciate your efforts in completing the verification, but unfortunately, it did not meet our requirements at this time.</p>
    
        <p>If you have any questions or concerns about the rejection, please feel free to contact our support team at eatseasy.services@gmail.com or +639294983155. Our team will be happy to provide further clarification and guidance on the verification process.</p>
    
        <p>Thank you for your understanding.</p>
    
        <p>Best regards,</p>
    
        <p>Dre<br>
        The Delegate<br>
        EatsEasy Support Team</p>`

    };

    try {
        await transporter.sendMail(mailOptions);
        console.log("Verification email sent");
    } catch (error) {
        console.log("Email sending failed with an error: ", error);
    }
}

module.exports = rejectionDriverEmail;