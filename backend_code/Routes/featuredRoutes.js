import express from "express";
import  featuredController  from "../controllers/featuredControllers.js";
const featuredRouter = express.Router();
const {createProductFeatured,getAllFeaturedProducts,getAllRequestedFeaturedProducts,getUserFeaturedProducts,updateFeaturedProducts}=featuredController;

featuredRouter.get("/getAllFeaturedProducts",getAllFeaturedProducts);
featuredRouter.get("/getAllRequestedFeaturedProducts",getAllRequestedFeaturedProducts);
featuredRouter.get("/getUserFeaturedProducts/:id",getUserFeaturedProducts);
featuredRouter.post("/createProductFeatured/:id",createProductFeatured);
featuredRouter.put("/updateFeaturedProducts/:id",updateFeaturedProducts);

export default featuredRouter;
