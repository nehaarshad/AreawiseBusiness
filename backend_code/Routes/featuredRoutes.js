import express from "express";
import  featuredController  from "../controllers/featuredControllers.js";
const featuredRouter = express.Router();
const {createProductFeatured,getAllFeaturedProducts,getAllRequestedFeaturedProducts,getUserFeaturedProducts,updateFeaturedProducts,deleteFeaturedProducts}=featuredController;

featuredRouter.get("/getAllFeaturedProducts/:Category",getAllFeaturedProducts);
featuredRouter.get("/getAllRequestedFeaturedProducts",getAllRequestedFeaturedProducts);
featuredRouter.get("/getUserFeaturedProducts/:id",getUserFeaturedProducts);
featuredRouter.post("/createProductFeatured/:id",createProductFeatured);
featuredRouter.put("/updateFeaturedProducts/:id",updateFeaturedProducts);
featuredRouter.delete("/deleteFeaturedProducts/:id",deleteFeaturedProducts);

export default featuredRouter;
