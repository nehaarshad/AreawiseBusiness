import sequelize from "../config/db_config.js";
import User from "../models/userModel.js";
import Product from "./productmodel.js";
import Shop from "./shopmodel.js";
import Address from "./addressmodel.js";
import TokenBlacklist from "./tokenblacklist.js";
import relation from "./relations.js";
import category from "./categoryModel.js";
import subcategory from "./subCategoryModel.js";
import image from "./imagesModel.js";

relation();

const models={
    User,
    category,
    subcategory,
    image,
    Product,
    Shop,
    Address,
    TokenBlacklist
}

const modelsSync=async()=>{
    try{

        await sequelize.sync({ force: false}).then(() => {   
            console.log("All models are synchronized successfully");
        }).catch((err) => {
            console.log("all models are not synchronized successfully",err)
         });
        }
    catch(err){
        console.log("Failed to synchronized Models",err)
    }
}

export default {models,modelsSync}
