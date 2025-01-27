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

dotenv.config();

const app=express();
app.use(bodyparser.json())
app.use(bodyparser.urlencoded({extended:true}))
app.use(cors());


modelsSyncs.modelsSync()
.then(()=>{
  const port=5000
  app.listen(port,()=>{
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


app.get("/",(req,res)=>{
    res.send("<h1> E-Commerce F-17 </h1>")
})