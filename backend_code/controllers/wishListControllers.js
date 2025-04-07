import wishList from "../models/wishListModel.js";
import User from "../models/userModel.js";
import Product from "../models/productModel.js";
import image from "../models/imagesModel.js";
import category from "../models/categoryModel.js";
import subcategories from "../models/subCategoryModel.js";
import { where } from "sequelize";

const AddToWishList = async (req, res) => {
    try {
        //get user id
        const {id}=req.params;
        const { productId } = req.body; //product id to  add to wishlist
        const user=await User.findByPk(id);
        const product = await Product.findByPk(productId);
       if(!user || !product){  
            return res.json({message:"User or Product not found"});
        }

        const existingwishListItem = await wishList.findOne({
            where:{
            userId: id,
            productId: productId
        }});

        if(existingwishListItem){
            return res.json({
                message:"Product Already in WithList",
                WishList:existingwishListItem
            })
        }

        const wishListItem = await wishList.create({
            userId: id,
            productId: productId
        });
        return res.json(wishListItem);
    } catch (error) {
        console.error('Error in AddToWishList:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
};

const GetWishList = async (req, res) => {
    try {
        const { id } = req.params;

        const wishListItems = await wishList.findAll({
            where: { userId: id }, 
            include: [
                {
                    model: Product,
                    include: [
                        {
                            model: image,
                            where: { imagetype: 'product' },
                            required: false // Ensures it still returns results even if no images exist
                        },
                        { model: category },
                        { model: subcategories }
                    ]
                }
            ]});

        return res.json(wishListItems);
    } catch (error) {
        console.error('Error in GetWishList:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
};

const RemoveFromWishList = async (req, res) => {
    try {
        const { id } = req.params;
        const { productId } = req.body;

        const deleted = await wishList.destroy({
            where: { userId:id, productId }
        });

        return res.json({ deleted });
    } catch (error) {
        console.error('Error in RemoveFromWishList:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
};

export default { AddToWishList, GetWishList, RemoveFromWishList };