import express from "express";
import  userController  from "../controllers/userControllers.js";
import upload from "../MiddleWares/uploadimage.js";
const userRouter = express.Router();
const {getallusers,getusers,getuser,getuserbyid,addUser,updateuser,changePassword,deleteuser}=userController;

userRouter.get("/getallusersbyrole/:role",getusers);
userRouter.get("/getuserbyid/:id",getuserbyid);
userRouter.get("/getuserbyname/:username",getuser);
userRouter.get("/getallusers",getallusers);
userRouter.post("/adduser",upload.single('image'),addUser);
userRouter.put("/updateuser/:id",upload.single('image'),updateuser);
userRouter.put("/changePassword/:id",changePassword);
userRouter.delete("/deleteuser/:id",deleteuser);

export default userRouter;
