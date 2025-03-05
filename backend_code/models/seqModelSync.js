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
import Ads from "./adsModel.js"
import cart from "./CartModel.js";
import order from "./orderModel.js";
import SellerOrder from "./sellerOrderModel.js";
import wishList from "./wishListModel.js";
import items from "./cartItemModel.js";
import featured from "./featuredModel.js";

relation();

const models={
    items,
    cart,
    wishList,
    order,
    SellerOrder,
    User,
    category,
    subcategory,
    image,
    Product,
    Shop,
    Address,
    Ads,
    featured,
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
