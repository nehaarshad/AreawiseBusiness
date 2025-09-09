import express from "express";
import  adsController  from "../controllers/adsControllers.js";
import {upload} from "../MiddleWares/uploadimage.js";
const adsRouter = express.Router();
const {createAd,getAllAds,getUserAds,deleteAd}=adsController;

adsRouter.get("/getAllAds",getAllAds);
adsRouter.get("/getUserAds/:id",getUserAds);
adsRouter.post("/createAd/:id",upload.single('image'),createAd);
adsRouter.delete("/deleteAd/:id",deleteAd);

export default adsRouter;
