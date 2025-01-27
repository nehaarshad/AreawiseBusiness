import express from 'express';
import productControllers from '../controllers/productControllers.js';
const { addproduct, getallproducts,getuserproducts,getshopproducts,updateproduct, deleteproduct } = productControllers;
const productRouter = express.Router();

productRouter.post("/addproduct/:id",addproduct);
productRouter.get("/getallproducts",getallproducts);
productRouter.get("/getuserproducts/:id",getuserproducts);
productRouter.get("/getshopproducts/:id",getshopproducts);
productRouter.put("/updateproduct/:id",updateproduct);
productRouter.delete("/deleteproduct/:id",deleteproduct);

export default productRouter;