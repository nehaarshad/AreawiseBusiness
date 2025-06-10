import express from 'express';
import categoryControllers from '../controllers/categoryControllers.js';
const {getallcategories,getallsubcategories,getsubcategoriesofcategory,addcategory,addsubcategory,deletecategory,deletesubcategory}= categoryControllers;
const categoryRouter = express.Router();

categoryRouter.get("/getCategories", getallcategories);
categoryRouter.get("/getallsubcategories", getallsubcategories);
categoryRouter.get("/getsubcategoriesofcategory/:categories", getsubcategoriesofcategory);
categoryRouter.post("/addcategory", addcategory);
categoryRouter.post("/addsubcategory", addsubcategory);
categoryRouter.delete("/deletecategory/:id", deletecategory);
categoryRouter.delete("/deletesubcategory/:id", deletesubcategory);

export default categoryRouter;