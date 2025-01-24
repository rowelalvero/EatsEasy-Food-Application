# EatsEasy System

Welcome to the EatsEasy System! This repository contains the source code and documentation for the EatsEasy application, a comprehensive food ordering and delivery platform.

## Technology Stack

- **Backend**:
  - Node.js with Express framework for REST API
  - MongoDB as the database
  - Nodemailer for email functionalities
- **Frontend**:
  - Flutter for mobile apps (User, Vendor, Delivery, and Super Admin)
  - Web app interface for User, Vendor, and Admin
- **Services**:
  - Firebase for notifications
  - Stripe for payment integration

## Project Features

The EatsEasy platform consists of the following components:

1. **EatsEasy User App**:
   - Chatting with vendors
   - Email and phone number verification
   - Product search, order placement, and history
   - Location-based services and promotions
   - Loyalty programs
   - Feedback system
   - Stripe integration for secure payments

2. **EatsEasy Vendor App**:
   - Menu creation and management
   - Order management (pending, confirmed, processing, delivering)
   - Sales tracking and reporting
   - Vendor-to-user chat feature
   - Payment requests and verification

3. **EatsEasy Driver App**:
   - Order acceptance and cancellation
   - Delivery status tracking and management
   - Delivery earnings overview

4. **EatsEasy Admin App**:
   - Restaurant and driver verification
   - Order tracking and management
   - Financial transaction management
   - Customer feedback monitoring
   - Commission and rates management

5. **EatsEasy Web App**:
   - Provides access for users, vendors, and admins to manage their respective functionalities.

## Key Features

### EatsEasy User App
- Secure login with email verification.
- Browse and search nearby restaurants or shops.
- Place orders with customizable options.
- Payment via Stripe or Cash on Delivery (COD).
- Real-time order tracking and notifications.

### EatsEasy Vendor App
- Upload restaurant details, food images, and descriptions.
- Create and manage food categories, tags, and prices.
- Handle incoming orders and communicate with users.
- Request payouts directly from the app.

### EatsEasy Driver App
- Manage deliveries and track orders.
- Real-time order pickup and drop-off updates.
- Wallet feature for managing COD transactions.

### EatsEasy Admin App
- Approve or reject vendor and driver accounts.
- View and manage all orders and transactions.
- Create and organize food categories.
- Review customer feedback and manage ratings.

## Installation and Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/<your-repo>/eats-easy.git
   ```
2. Navigate to the backend folder and install dependencies:
   ```bash
   cd backend
   npm install
   ```
3. Set up the MongoDB database and configure environment variables.
4. Start the server:
   ```bash
   npm start
   ```
5. Navigate to the frontend folder for mobile and web apps:
   ```bash
   cd frontend
   flutter run
   ```

## Contribution Guidelines

1. Fork the repository and create a feature branch.
2. Commit your changes with clear messages.
3. Submit a pull request for review.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

---

Would you like me to make any adjustments or add specific sections?
