import express from "express";
import cors from "cors";
import bodyparser from "body-parser";
import  sequelize  from "./backend_code/config/db_config.js";
import dotenv from "dotenv"
import modelsSyncs from "./backend_code/models/seqModelSync.js";
import authroutes from "./backend_code/Routes/authRoutes.js";
import userRouter from "./backend_code/Routes/userRoutes.js";
import productRouter from "./backend_code/Routes/productRoutes.js";
import shopRouter from "./backend_code/Routes/shopRoutes.js";
import addressRouter from "./backend_code/Routes/addressRoutes.js";
import cartRouter from "./backend_code/Routes/cartRoutes.js";
import orderRouter from "./backend_code/Routes/orderRoutes.js";
import categoryRouter from "./backend_code/Routes/categoryRoutes.js";
import wishListRoutes from "./backend_code/Routes/wishListRoutes.js";
import SellerOrderRouter from "./backend_code/Routes/sellerOrderRoutes.js";
import chatRouter from "./backend_code/Routes/chatRoutes.js";
import adsRouter from "./backend_code/Routes/adsRoutes.js"
import path from "path";
import scheduler from "./backend_code/services/scheduler.js";
import featuredRouter from "./backend_code/Routes/featuredRoutes.js"
import { fileURLToPath } from "url";
import  http  from 'http';
import { Server } from 'socket.io';
import chatService from "./backend_code/services/chatService.js";
import reviewsRouter from "./backend_code/Routes/reviewsRoutes.js";

dotenv.config();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app=express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
  },
  transports: ['websocket']
});

chatService(io); // Initialize chat service with socket.io instance

app.use(bodyparser.json())
app.use(bodyparser.urlencoded({extended:true}))
app.use(cors());
app.use("/backend_code/uploads", express.static(path.join(__dirname, "backend_code/uploads")));

modelsSyncs.modelsSync()
.then(()=>{
  const port=5000
  server.listen(port, () => {
      console.log(`Server Runnind on Port ${port}`)
  })
})
.catch((err)=>{
  console.log("Failed to synchronize models:",err)
})

  sequelize.authenticate()
.then(()=>{
    console.log("Database is Connected SUCCESSFULLY");
})
.catch((err)=>{
  console.error("Failed to authenticate database:", err);
})


app.use("/api",authroutes );
app.use("/api",userRouter);
app.use("/api",productRouter);
app.use("/api",shopRouter);
app.use("/api",addressRouter);
app.use("/api",categoryRouter);
app.use("/api",cartRouter);
app.use("/api",orderRouter);
app.use("/api",wishListRoutes);
app.use("/api",adsRouter);
app.use("/api",SellerOrderRouter);
app.use("/api",featuredRouter);
app.use("/api",chatRouter);
app.use("/api",reviewsRouter);

scheduler();

app.get("/",(req,res)=>{
    res.send("<h1> E-Commerce F-17 </h1>")
})