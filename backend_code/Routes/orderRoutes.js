import express from "express";
import orderControllers from "../controllers/orderControllers.js";
const { ViewCheckout, PlaceOrder } = orderControllers;

const orderRouter = express.Router();
orderRouter.get("/ViewCheckout/:id", ViewCheckout);
orderRouter.post("/PlaceOrder", PlaceOrder);

export default orderRouter;
