import express from "express";
import cartControllers from "../controllers/cartControllers.js";
const { getCart, addToCart, updateCartItem, removeCartItem ,updateCart,deleteUserCart} = cartControllers;

const cartRouter = express.Router();
cartRouter.get("/getCart/:id", getCart);
cartRouter.post("/addToCart/:id", addToCart);
cartRouter.put("/updateCartItem/:id", updateCartItem);
cartRouter.put("/updateCart/:id", updateCart);
cartRouter.delete("/removeCartItem/:id", removeCartItem);
cartRouter.delete("/deleteCart/:id", deleteUserCart);

export default cartRouter;
