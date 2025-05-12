import express from "express";
import authControllers from "../controllers/authControllers.js"
const { createNewUser, loginUser ,logout,forgetPassword}=authControllers;

const authroute = express.Router();

authroute.post("/signup", createNewUser);
authroute.post("/login", loginUser);
authroute.post("/logout", logout);
authroute.post("/forgetpassword", forgetPassword);

export default authroute;
