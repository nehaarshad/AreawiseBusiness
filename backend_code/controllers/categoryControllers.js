import category from "../models/categoryModel.js";
import subcategories from "../models/subCategoryModel.js";

const getallcategories = async (req, res) => {
    try {
        const categories = await category.findAll();
        res.json(categories);
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to find categories" });
    }
};
const getallsubcategories = async (req, res) => {
    try {
        const subcategory = await subcategories.findAll();
        res.json(subcategory);
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to find Subcategories" });
    }
};
const getsubcategoriesofcategory = async (req, res) => {
    try {
        const {categories}=req.params;
        const findcategory=await category.findOne({where:{name:categories}})
        if(!findcategory){
            res.json({ message: "No Category Found" });
        }
        const subcategory = await subcategories.findAll({where:{categoryId:findcategory.id}});
        if(!subcategory){
            res.json({ message: "No Subcategories" });
        }
        res.json(subcategory);
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to find Subcategories" });
    }
};

export default {getallcategories,getallsubcategories,getsubcategoriesofcategory}