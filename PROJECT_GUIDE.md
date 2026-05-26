# 🍕 Food Express - Complete Project & Technical Guide

Welcome to **Food Express**, a modern, full-stack MERN food delivery application designed for speed, security, and an exceptional user experience. This guide contains everything you need to understand the project architecture, file structure, database, APIs, and key technologies.

---

## 1. 📝 Project Overview
Food Express is a comprehensive solution for online food ordering. It connects users with local restaurants, allowing for seamless browsing, real-time order tracking, and secure payments. 
The platform includes:
- **User Facing App**: For discovering food, adding to cart, checkout, payment, and real-time order tracking.
- **Admin/Owner Panel**: For managing users, restaurants, menu items, resolving reviews, and tracking incoming orders in real-time.
- **Rider Simulation**: A system to simulate rider assignment, location updates, and delivery statuses.

---

## 2. 🛠 Technology Stack (Detailed)

### **Backend (Node.js Environment)**
- **Express.js**: Core server framework used to create RESTful APIs.
- **MongoDB & Mongoose**: NoSQL database. Mongoose is used as the ODM (Object Data Modeling) library for schema validation and database interactions.
- **Socket.io**: Used for real-time bidirectional event-based communication. Handles live location updates of riders and instant order status changes.
- **JWT (JSON Web Token)**: Used for secure stateless authentication and authorization (via Cookies/Headers).
- **Nodemailer**: For sending automated transactional emails such as OTP verification.
- **Razorpay SDK**: Integrated for professional payment processing (Cards, UPI, NetBanking).
- **Bcrypt.js**: For hashing passwords before saving to the database.

### **Frontend (React Environment)**
- **React (Vite)**: Vite is used as the build tool for an extremely fast development server and optimized production build.
- **Redux Toolkit**: Centralized state management. Stores global states like User info, Cart items, and active tracking data.
- **React Router DOM**: Client-side routing for navigating between pages without reloading.
- **Axios**: Promised-based HTTP client to make API requests to the Node.js server.
- **Google Maps API / Leaflet**: For rendering maps during live order tracking.
- **Vanilla CSS3**: Custom styles (Glassmorphism, hover effects, CSS variables for theming) for a unique and highly premium UI/UX.

---

## 3. 📁 Directory Structure & Files Explained

```bash
online-food-delivery/
├── backend/                  # Server-side code (Node/Express)
│   ├── config/               # Database connection (e.g., db.js)
│   ├── controllers/          # Business logic handlers
│   │   ├── userController.js # Auth, OTP, Profile updates
│   │   ├── orderController.js# Order placement, tracking logic
│   │   ├── paymentController.js # Razorpay integration
│   │   └── ...
│   ├── middleware/           # Intercepts requests (authMiddleware.js, error middleware)
│   ├── models/               # Mongoose DB Schemas
│   │   ├── User.js, Order.js, Restaurant.js, FoodItem.js, Category.js...
│   ├── routes/               # Express router mapping to controllers
│   │   ├── userRoutes.js, orderRoutes.js, paymentRoutes.js...
│   ├── utils/                # Utility scripts (Generate OTP, Email Sender)
│   ├── seedAll.js            # Initial dummy data seeder script
│   ├── server.js             # Entry Point for Node.js Server
│   └── package.json          # Backend dependencies
│
├── frontend/                 # Client-side code (React/Vite)
│   ├── public/               # Static assets (images, icons)
│   ├── src/
│   │   ├── components/       # Reusable modular UI elements (Navbar, Footer, Cart, etc.)
│   │   ├── pages/            # View components tied to routes
│   │   │   ├── HomePage.jsx, AuthPage.jsx, CheckoutPage.jsx, OrderTrackingPage.jsx
│   │   │   └── ...
│   │   ├── redux/            # State management slices & store
│   │   │   ├── userSlice.js, cartSlice.js, store.js
│   │   ├── App.jsx           # Main layout & Route definitions
│   │   ├── main.jsx          # React DOM render entry point
│   │   ├── index.css         # Global CSS styles & Design System Variables
│   └── package.json          # Frontend dependencies
│
└── Launch_FoodExpress.bat    # Windows Batch script to start both end concurrently
```

---

## 4. 🗄️ Database Schemas (Models Highlight)

1. **User Schema (`User.js`)**: 
   - Fields: `name`, `email`, `password`, `role` (user/admin/rider), `addresses`, `isVerified`.
2. **Restaurant Schema (`Restaurant.js`)**: 
   - Fields: `name`, `ownerId`, `address`, `rating`, `cuisineType`, `isOpen`.
3. **FoodItem Schema (`FoodItem.js`)**: 
   - Fields: `name`, `description`, `price`, `image`, `restaurantId`, `categoryId`, `isAvailable`.
4. **Order Schema (`Order.js`)**: 
   - Fields: `userId`, `restaurantId`, `items` (array of food items & quantity), `totalAmount`, `status` (Pending, Preparing, Out for Delivery, Delivered), `paymentStatus` (Pending, Paid, Failed), `deliveryAddress`.
5. **Category Schema (`Category.js`)**:
   - Fields: `name`, `image`.

---

## 5. 🔌 Core API Endpoints

The API follows RESTful conventions. Base URL is generally `http://localhost:5000/api`.

### **Authentication & Users (`/api/users`)**
- `POST /register`: Register a new user, sends OTP via Email.
- `POST /verify-otp`: Verifies the given OTP and creates the account.
- `POST /login`: Authenticates the user and returns a JWT.
- `GET /profile`: Fetch the logged-in user's profile (requires Auth).

### **Orders (`/api/orders`)**
- `POST /`: Place a new order (saves items, totals to DB).
- `GET /my-orders`: Retrieve purchase history for the logged-in user.
- `PUT /:id/status`: (Admin/Rider) Update an order's status (e.g., preparing -> delivered).

### **Payments (`/api/payments`)**
- `POST /create-order`: Generates a Razorpay Order ID for frontend checkout.
- `POST /verify`: Verifies the Razorpay payment signature & confirms payment.

### **Menu & Restaurants (`/api/restaurants`, `/api/fooditems`)**
- `GET /`: Fetch list of available restaurants or food items.
- `POST /`: (Admin) Add new food or restaurant.

---

## 6. 🚀 Advanced Features Explained

### **Real-Time Tracking (Socket.io)**
When an order's status is changed by the Admin (e.g., to "Out for Delivery"), the backend emits a Socket event to the specific `orderRoom`. The frontend (`OrderTrackingPage.jsx`) listens to this real-time stream to instantly update the UI without needing to refresh the page. Riders also emit their GPS coordinates for live mapping.

### **Redux Global State**
Instead of manually passing props everywhere:
- `cartSlice.js`: Manages adding/removing items to cart, calculating total price.
- `userSlice.js`: Holds user session (logged in status, token, user profile).

### **Payment Flow (Razorpay)**
1. User clicks "Pay".
2. Frontend calls Backend `/create-order` to generate a secure Razorpay Session ID.
3. Razorpay window pops up. User makes the payment.
4. Razorpay sends a `payment_id` and `signature` to the Frontend upon success.
5. Frontend calls Backend `/verify` with this data to validate against tampering.
6. Order is successfully marked as "Paid".

---

## 7. 🐞 Recent Bug Fixes (Project Maturity)
1. **Price Display Fixed**: Resolved `NaN` pricing issues in the cart by strictly enforcing Number typing during the Add-To-Cart actions and formatting mongoose Schema values properly.
2. **Auth Page UI**: Fixed layout overlaps in `AuthPage.css` so icons don't overlap with input text fields.
3. **Admin Routing**: Resolved blank pages in the Admin dashboard by properly nesting `<Outlet />` routing maps in React Router.
4. **Guest Protection**: Non-logged in users attempting to checkout are gracefully redirected to the Login page before proceeding with payments.

---

## 8. 🏃 How to Run the Project Locally

### Option 1: One-Click Launch (Windows)
Double-click the **`Launch_FoodExpress.bat`** file located in the root directory. It will automatically start the Backend server, the Frontend Vite server, and prompt open your web browser.

### Option 2: Manual Terminal Setup

1. **Start the Backend Server**:
   ```bash
   cd backend
   npm install         # Install all dependencies required
   npm run dev         # Starts Nodemon watcher on port 5000
   ```
   *(Ensure you have setup a `.env` in the backend with `MONGO_URI`, `JWT_SECRET`, and `RAZORPAY` credentials)*

2. **Start the Frontend Application**:
   ```bash
   cd frontend
   npm install         # Install React modules
   npm run dev         # Starts Vite server on port 5173
   ```

3. **Populate Database (Optional but recommended)**:
   ```bash
   cd backend
   node seedAll.js     # Automatically fills DB with dummy restaurants and food
   ```

---

*This guide covers the entire technical scope of the Food Express system. Read through the specific controller or component files for lower-level code implementation details.*
