import express from "express";
import  userController  from "../controllers/userControllers.js";
import upload from "../MiddleWares/uploadimage.js";
const userRouter = express.Router();
const {getallusers,getusers,getuser,getuserbyid,updateuser,deleteuser}=userController;

userRouter.get("/getallusersbyrole/:role",getusers);
userRouter.get("/getuserbyid/:id",getuserbyid);
userRouter.get("/getuserbyname/:username",getuser);
userRouter.get("/getallusers",getallusers);
userRouter.put("/updateuser/:id",upload.array('image',1),updateuser);
userRouter.delete("/deleteuser/:id",deleteuser);

export default userRouter;
