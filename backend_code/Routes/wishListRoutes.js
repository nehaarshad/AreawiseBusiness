import express from "express"
import wishListControllers from "../controllers/wishListControllers.js"
const {AddToWishList, GetWishList, RemoveFromWishList } = wishListControllers;

const wishListRoutes=express.Router();

wishListRoutes.get("/GetWishList/:id",GetWishList);
wishListRoutes.post("/AddToWishList/:id",AddToWishList);
wishListRoutes.delete("/RemoveFromWishList/:id",RemoveFromWishList);

export default wishListRoutes;