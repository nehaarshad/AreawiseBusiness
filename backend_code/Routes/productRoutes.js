import express from 'express';
import productControllers from '../controllers/productControllers.js';
import upload from '../MiddleWares/uploadimage.js';
const { addproduct, getallproducts,getuserproducts,getshopproducts,updateproduct, deleteproduct } = productControllers;
const productRouter = express.Router();

productRouter.post("/addproduct/:id",upload.array('products',5),addproduct);
productRouter.get("/getallproducts",getallproducts);
productRouter.get("/getuserproducts/:id",getuserproducts);
productRouter.get("/getshopproducts/:id",getshopproducts);
productRouter.put("/updateproduct/:id",updateproduct);
productRouter.delete("/deleteproduct/:id",deleteproduct);

export default productRouter;