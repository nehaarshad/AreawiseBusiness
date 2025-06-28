import express from 'express';
import categoryControllers from '../controllers/categoryControllers.js';
import upload from "../MiddleWares/uploadimage.js";
const {getallcategories,getallsubcategories,getsubcategoriesofcategory,addcategory,addsubcategory,deletecategory,deletesubcategory}= categoryControllers;
const categoryRouter = express.Router();


categoryRouter.get("/getCategories", getallcategories);
categoryRouter.get("/getallsubcategories", getallsubcategories);
categoryRouter.get("/getsubcategoriesofcategory/:categories", getsubcategoriesofcategory);
categoryRouter.post("/addcategory",upload.single('image'), addcategory);
categoryRouter.post("/addsubcategory", addsubcategory);
categoryRouter.delete("/deletecategory/:id", deletecategory);
categoryRouter.delete("/deletesubcategory/:id", deletesubcategory);

export default categoryRouter;