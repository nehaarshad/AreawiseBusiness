import express from 'express';
import productControllers from '../controllers/productControllers.js';
import {upload} from '../MiddleWares/uploadimage.js';
const { addproduct,getProductsOnSale,updateproductArrivalDays,getproductArrivalDays, findproductbyid,getallproducts,getuserproducts,getshopproducts,getProductBySubcategory,getNewArrivalproducts,getProductByName,updateproduct, deleteproduct } = productControllers;
const productRouter = express.Router();

productRouter.post("/addproduct/:id",upload.array('image',8),addproduct);
productRouter.get("/getallproducts/:Category",getallproducts);
productRouter.get("/getProductsOnSale/:Category",getProductsOnSale);
productRouter.get("/getproducts/:id",findproductbyid);
productRouter.get("/getuserproducts/:id",getuserproducts);
productRouter.get("/getshopproducts/:id",getshopproducts);
productRouter.put("/updateproductArrivalDays",updateproductArrivalDays);
productRouter.get("/getproductArrivalDays",getproductArrivalDays);
productRouter.get("/getProductBySubcategory/:subcategory",getProductBySubcategory);
productRouter.get("/getNewArrivalproducts/:Category",getNewArrivalproducts);
productRouter.get("/getProductByName/:name",getProductByName);
productRouter.put("/updateproduct/:id",upload.array('image',8),updateproduct);
productRouter.delete("/deleteproduct/:id",deleteproduct);

export default productRouter;