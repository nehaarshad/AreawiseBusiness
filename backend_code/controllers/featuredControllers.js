import featured from "../models/featuredModel.js";
import Product from "../models/productModel.js";
import image from "../models/imagesModel.js";
import User from "../models/userModel.js";
import category from "../models/categoryModel.js";
import { Op } from "sequelize";

//by seller...
const createProductFeatured=async(req,res)=>{
    try {
        const {id}=req.params; //userID
        const {productID,expire_at}=req.body;
        const reqProduct=await featured.create({productID,userID:id,expire_at});
        res.status(201).json(reqProduct);
    } catch (error) {
        console.log(error);
    }
}

//for seller...
const getUserFeaturedProducts=async(req,res)=>{
    try {
        const {id}=req.params; //userID
        const featuredProduct=await featured.findAll({
            where:{id}, 
            include: {
                    model: Product,
                    include:{
                        model: image,
                        where: { imagetype: "product" },
                        required: false
                    }
                }
        })
        res.status(201).json(featuredProduct);
    } catch (error) {
        console.log(error);
    }
}

//dashboard...
const getAllFeaturedProducts=async(req,res)=>{
    try {
        const featuredProduct=await featured.findAll({
            where:{status:"Featured"}, 
            include: {
                    model: Product,
                    include:{
                        model: image,
                        where: { imagetype: "product" },
                        required: false
                    }
                }
        })
        res.status(201).json(featuredProduct);
    } catch (error) {
        console.log(error);
    }
}

//for admin...
const getAllRequestedFeaturedProducts=async(req,res)=>{
    try {
        const currentDate=new Date()
        const featuredProduct=await featured.findAll({
            where:{status:"Requested",expire_at:{ [Op.gt]: currentDate }, }, 
            include: [
                {
                    model: Product,
                    include:[{
                        model: image,
                        where: { imagetype: "product" },
                        required: false
                    },
                {
                    model:category
                }],
                },
                {
                model:User
                }]
        })
        res.status(201).json(featuredProduct);
    } catch (error) {
        console.log(error);
    }
}

//by admin...
const updateFeaturedProducts=async(req,res)=>{
    try {
        const {id}=req.params; //featuredID
        const {status}=req.body;
        const requestedFeaturedProduct=await featured.findByPk(id,{
        include: {
                    model: Product,
                    include:{
                        model: image,
                        where: { imagetype: "product" },
                        required: false
                    }
                }
    })

    const updated=await requestedFeaturedProduct.update({status});  //to featured or rejected
        res.status(201).json(updated);
    } catch (error) {
        console.log(error);
    }
}

export default {createProductFeatured,getAllFeaturedProducts,getAllRequestedFeaturedProducts,getUserFeaturedProducts,updateFeaturedProducts}