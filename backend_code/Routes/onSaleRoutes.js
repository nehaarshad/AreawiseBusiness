import express from "express";
import onSaleControllers from "../controllers/onSaleControllers.js";
const {addOnSale,updateOnSaleProduct,getUserSaleProducts,deleteOnSale} = onSaleControllers;

const salesRouter = express.Router();
salesRouter.get("/getUserSaleProducts/:id", getUserSaleProducts);
salesRouter.put("/updateOnSaleProduct/:id", updateOnSaleProduct);
salesRouter.post("/addOnSale/:id", addOnSale);
salesRouter.delete("/deleteOnSale/:id", deleteOnSale);

export default salesRouter;
