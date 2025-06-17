import express from "express";
import orderControllers from "../controllers/orderControllers.js";
const { ViewCheckout, PlaceOrder ,getDeliveryOrderAttributes,updateDeliveryOrderAttributes} = orderControllers;

const orderRouter = express.Router();
orderRouter.get("/getDeliveryOrderAttributes", getDeliveryOrderAttributes);
orderRouter.post("/ViewCheckout/:id", ViewCheckout);
orderRouter.post("/PlaceOrder", PlaceOrder);
orderRouter.put("/updateDeliveryOrderAttributes", updateDeliveryOrderAttributes);

export default orderRouter;
