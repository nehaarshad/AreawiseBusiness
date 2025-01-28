import express from 'express';
import categoryControllers from '../controllers/categoryControllers.js';
const {getallcategories,getallsubcategories,getsubcategoriesofcategory}= categoryControllers;
const categoryRouter = express.Router();

categoryRouter.get("/getCategories", getallcategories);
categoryRouter.get("/getallsubcategories", getallsubcategories);
categoryRouter.get("/getsubcategoriesofcategory/:categories", getsubcategoriesofcategory);

export default categoryRouter;