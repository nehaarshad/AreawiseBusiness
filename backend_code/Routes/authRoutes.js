import express from "express";
import authControllers from "../controllers/authControllers.js"
const { createNewUser, loginUser ,logout}=authControllers;

const authroute = express.Router();

authroute.post("/signup", createNewUser);
authroute.post("/login", loginUser);
authroute.post("/logout", logout);

export default authroute;
