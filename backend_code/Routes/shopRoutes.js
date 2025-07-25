import express from 'express';
import shopControllers from '../controllers/shopControllers.js';
import upload from '../MiddleWares/uploadimage.js';
const {addshop,getShopByName,getallshops,getusershop,updateshop,updateShopStatus,getshopcategory,getshopId,deleteshopbyid} = shopControllers;
const shopRouter = express.Router();

shopRouter.post("/addshop/:id",upload.array('image',5),addshop);
shopRouter.get("/getallshops",getallshops);
shopRouter.get("/getusershop/:id",getusershop);
shopRouter.put("/updateshop/:id",upload.array('image',5),updateshop);
shopRouter.put("/updateShopStatus/:id",updateShopStatus)
shopRouter.get("/getshopById/:id",getshopId);
shopRouter.get("/getShopByName/:name",getShopByName);
shopRouter.get("/getshopByCategory/:category",getshopcategory);
shopRouter.delete("/deleteshopbyid/:id",deleteshopbyid);

export default shopRouter;