import express from 'express';
import shopControllers from '../controllers/shopControllers.js';
import upload from '../MiddleWares/uploadimage.js';
const {addshop,getallshops,getusershop,updateshop,getshopcategory,getshopName,deleteshopbyid} = shopControllers;
const shopRouter = express.Router();

shopRouter.post("/addshop/:id",upload.array('image',5),addshop);
shopRouter.get("/getallshops",getallshops);
shopRouter.get("/getusershop/:id",getusershop);
shopRouter.put("/updateshop/:id",upload.array('image',5),updateshop);
shopRouter.get("/getshopByName/:shopname",getshopName);
shopRouter.get("/getshopByCategory/:category",getshopcategory);
shopRouter.delete("/deleteshopbyid/:id",deleteshopbyid);

export default shopRouter;