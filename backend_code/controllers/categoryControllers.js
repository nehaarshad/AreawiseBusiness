import category from "../models/categoryModel.js";
import image from "../models/imagesModel.js";
import subcategories from "../models/subCategoryModel.js";
import path from "path";
import dotenv from "dotenv";
import { fileURLToPath } from "url";
import { optimizeImage } from "../MiddleWares/uploadimage.js";
const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);
dotenv.config();
import removeImageFromDirectory from "../utils/deleteImageFromDirectory.js";

const getallcategories = async (req, res) => {
    try {
        const categories = await category.findAll({
            include: [{
                                model:image,
                                where:{imagetype:"category"},
                                required:false //all products may not have image
            }],
        });
        console.log(`${categories.length} Categories found`);
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
        const findcategory=await category.findOne({where:{name:categories},
        
            include: [{
                                model:image,
                                where:{imagetype:"category"},
                                required:false //all products may not have image
            }],
        
    })
        if(!findcategory){
           return res.json({ message: "No Category Found" });
        }
        const subcategory = await subcategories.findAll({where:{categoryId:findcategory.id}});
        if(!subcategory){
           return res.json({ message: "No Subcategories" });
        }
      return  res.json(subcategory);
    } catch (error) {
        console.log(error);
       return res.json({ error: "Failed to find Subcategories" });
    }
};

const addcategory = async (req, res) => {
    try {
        const { name } = req.body;
        
         console.log(req.file);
        const newCategory = await category.create({ name });
       if (req.file) {
        try {
                            const originalPath = req.file.path;
                            const optimizedFilename = 'optimized-' + req.file.filename;
                            const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
                            
                            // Optimize the image
                            await optimizeImage(originalPath, optimizedPath);
                             await image.create({ imagetype: 'category', CategoryId: newCategory.id,  imageUrl: `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`, });
        
                            
                        } catch (imageError) {
                            console.error('Error processing image:', req.file.filename, imageError);
                        
                        }
                  }
        res.json(newCategory);
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to add category" });
    }
};

const addsubcategory = async (req, res) => {
    try {
        const { name, categoryId } = req.body;
        const newSubcategory = await subcategories.create({ name, categoryId });
        res.json(newSubcategory);
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to add subcategory" });
    }
}

const deletecategory = async (req, res) => {
    try {
        const { id } = req.params;
        const deletedCategory = await category.findByPk(id);
        if (deletedCategory) {
            await subcategories.destroy({ where: { categoryId: id } });
              const oldImages = await image.findOne({
                where: { imagetype:"category",CategoryId:id }
            });

            // Delete old image files from filesystem
            if (oldImages) {
               await removeImageFromDirectory(oldImages.imageUrl);
            }
             const images=await image.destroy({where:{imagetype:"category",CategoryId:id}})
                    if(images>0){
                        console.log(`${images} Images of this category is deleted`)
                    }
            await deletedCategory.destroy();
            res.json({ message: "Category deleted successfully" });
        } else {
            res.json({ message: "Category not found" });
        }
       
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to delete category" });
    }
}   

const deletesubcategory = async (req, res) => {
    try {
        const { id } = req.params;
        const deletedSubcategory = await subcategories.destroy({ where: { id } });
        if (deletedSubcategory) {
             console.log("Subcategory deleted successfully");
           return res.json({ message: "Subcategory deleted successfully" });
        } else {
           return res.json({ message: "Subcategory not found" });
        }
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to delete subcategory" });
    }
}

export default {getallcategories,getallsubcategories,getsubcategoriesofcategory,addcategory,addsubcategory,deletecategory,deletesubcategory};