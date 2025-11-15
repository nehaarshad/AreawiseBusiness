import express from "express";
import cors from "cors";
import compression from "compression";
import bodyparser from "body-parser";
import  sequelize  from "./backend_code/config/db_config.js";
import dotenv from "dotenv"
import auth from "./backend_code/MiddleWares/authMiddleware.js";
import modelsSyncs from "./backend_code/models/seqModelSync.js";
import authroutes from "./backend_code/Routes/authRoutes.js";
import userRouter from "./backend_code/Routes/userRoutes.js";
import productRouter from "./backend_code/Routes/productRoutes.js";
import feedbackRouter from "./backend_code/Routes/feedbackRoutes.js";
import shopRouter from "./backend_code/Routes/shopRoutes.js";
import transcriptRouter from "./backend_code/Routes/transcriptRoutes.js";
import addressRouter from "./backend_code/Routes/addressRoutes.js";
import cartRouter from "./backend_code/Routes/cartRoutes.js";
import accountRouter from "./backend_code/Routes/accountRoutes.js";
import orderRouter from "./backend_code/Routes/orderRoutes.js";
import categoryRouter from "./backend_code/Routes/categoryRoutes.js";
import wishListRoutes from "./backend_code/Routes/wishListRoutes.js";
import SellerOrderRouter from "./backend_code/Routes/sellerOrderRoutes.js";
import chatRouter from "./backend_code/Routes/chatRoutes.js";
import adsRouter from "./backend_code/Routes/adsRoutes.js"
import path from "path";
import salesRouter from "./backend_code/Routes/onSaleRoutes.js";
import scheduler from "./backend_code/services/scheduler.js";
import featuredRouter from "./backend_code/Routes/featuredRoutes.js"
import { fileURLToPath } from "url";
import  http  from 'http';
import { Server } from 'socket.io';
import chatService from "./backend_code/services/chatService.js";
import reviewsRouter from "./backend_code/Routes/reviewsRoutes.js";
import reminderRouter from "./backend_code/Routes/orderReminderRoutes.js";

dotenv.config();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const server = http.createServer(app);

// Enhanced Socket.IO CORS configuration
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
    credentials: false
  },
  transports: ['websocket', 'polling'] // Add polling as fallback
});

const { userSockets } = chatService(io); 
app.use((req, res, next) => { //middleware to makeNotifications
  req.io = io;
  req.userSockets = userSockets;
  next();
});
// Request logging middleware (for debugging)
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path} - ${req.ip}`);
  next();
});

// Enhanced CORS configuration - MUST be before routes
app.use(cors({
  origin: "*", // In production, specify your allowed origins
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: [
    "Content-Type", 
    "Authorization", 
    "X-Requested-With", 
    "Accept",
    "Origin"
  ],
  credentials: false,
  optionsSuccessStatus: 200 // For legacy browser support
}));

// Handle preflight requests explicitly
app.options('*', (req, res) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With, Accept, Origin');
  res.sendStatus(200);
});

// Body parsing middleware
app.use(bodyparser.json({ limit: '10mb' }));
app.use(bodyparser.urlencoded({ extended: true, limit: '10mb' }));

// Static file serving
app.use("/backend_code/uploads", express.static(path.join(__dirname, "backend_code/uploads"), {
    maxAge: '1y', // Tells browsers to cache the image for 1 year.
    etag: true, //Enables ETag headers, which help browsers validate cached content.
    lastModified: true, //Adds a Last-Modified header for cache validation.
    cacheControl: true, //Enables Cache-Control headers.
    setHeaders: (res, path) => {
        if (path.endsWith('.webp') || path.endsWith('.jpg') || path.endsWith('.png')) {
            res.setHeader('Cache-Control', 'public, max-age=31536000'); // 1 year
        }
    }
}));

app.use(compression({
    filter: (req, res) => {
        if (req.headers['x-no-compression']) {
            return false;
        }
        return compression.filter(req, res);
    },
    level: 6,
    threshold: 1024
}));

// Security headers
app.use((req, res, next) => {
  res.header('X-Content-Type-Options', 'nosniff');
  res.header('X-XSS-Protection', '1; mode=block');
  // Don't set X-Frame-Options: DENY if you need to embed in iframes
  next();
});

// Health check route (no auth required)
app.get("/", (req, res) => {
  res.json({ 
    message: "E-Commerce F-17 API Server", 
    status: "running",
    timestamp: new Date().toISOString()
  });
});

// Test route without auth (for debugging)
app.get("/api/health", (req, res) => {
  res.json({ 
    message: "API is working", 
    status: "healthy",
    timestamp: new Date().toISOString()
  });
});

// API Routes - Define BEFORE server starts listening
app.use("/api", authroutes); // Auth routes (login/register) - no auth middleware
app.use("/api", auth, userRouter);
app.use("/api", auth, productRouter);
app.use("/api", auth, shopRouter);
app.use("/api", auth, addressRouter);
app.use("/api", auth, categoryRouter);
app.use("/api",auth,transcriptRouter);
app.use("/api",auth,feedbackRouter);
app.use("/api",auth,accountRouter);
app.use("/api", auth, cartRouter);
app.use("/api", auth, orderRouter);
app.use("/api", auth, reminderRouter);
app.use("/api", auth, wishListRoutes);
app.use("/api", auth, adsRouter);
app.use("/api", auth, SellerOrderRouter);
app.use("/api", auth, featuredRouter);
app.use("/api",auth,salesRouter);
app.use("/api", auth, chatRouter);
app.use("/api", auth, reviewsRouter);

// Error handling middleware (should be after routes)
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    message: err.message || 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// 404 handler (should be last)
app.use('*', (req, res) => {
  console.log(`404 - Route not found: ${req.method} ${req.originalUrl}`);
  res.status(404).json({ 
    message: 'Route not found',
    path: req.originalUrl,
    method: req.method
  });
});

// Database authentication
sequelize.authenticate()
  .then(() => {
    console.log("Database is Connected SUCCESSFULLY");
  })
  .catch((err) => {
    console.error("Failed to authenticate database:", err);
  });

// Start server AFTER all middleware and routes are defined
modelsSyncs.modelsSync()
  .then(() => {
    const port = 5000;
    server.listen(port, '0.0.0.0', () => { // Listen on all interfaces
      console.log(`Server Running on Port ${port}`);
      console.log(`Server accessible at http://161.35.22.15:${port}`);
      console.log(`Health check: http://161.35.22.15:${port}/api/health`);
    });
  })
  .catch((err) => {
    console.log("Failed to synchronize models:", err);
    process.exit(1);
  });

// Initialize scheduler
scheduler(io,userSockets);

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  server.close(() => {
    console.log('Process terminated');
  });
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully');
  server.close(() => {
    console.log('Process terminated');
  });
});