import express from 'express';
import sellerOrderControllers from '../controllers/sellerOrderControllers.js';
const { getSellerOrders,getCustomerOrders, updateOrderStatus } = sellerOrderControllers;  //arrayDestruction

const SellerOrderRouter = express.Router();
SellerOrderRouter.get("/seller/:id", getSellerOrders);
SellerOrderRouter.get("/customer/:id", getCustomerOrders);
SellerOrderRouter.put("/:id", updateOrderStatus);

export default SellerOrderRouter;
