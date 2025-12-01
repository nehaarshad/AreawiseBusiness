import featured from "../models/featuredModel.js";
import Product from "../models/productModel.js";
import image from "../models/imagesModel.js";
import User from "../models/userModel.js";
import category from "../models/categoryModel.js";
import subcategories from "../models/subCategoryModel.js";
import reviews from "../models/reviewModel.js";
import shop from "../models/shopmodel.js";
import sale from "../models/salesModel.js";
import sendNotificationToUser from "../utils/sendNotification.js";
import { Op } from "sequelize";

// seller request for feature product...
const createProductFeatured=async(req,res)=>{
    try {
        const {id}=req.params; //userID
        const userID=parseInt(id);
        const {productID}=req.body;
        const reqProduct=await featured.create({productID,userID});
        res.status(201).json(reqProduct);
    } catch (error) {
        console.log(error);
    }
}   

//for seller...
const getUserFeaturedProducts=async(req,res)=>{
    try {
        const {id}=req.params; //userID
        const userID=parseInt(id);
        console.log(userID);
        const featuredProduct=await featured.findAll({
            where:{userID}, 
             order: [['createdAt', 'DESC']], 
            include: {
                    model: Product,
                      include:[
            {
                model:image,
                where:{imagetype:"product"},
                required:false //all products may not have image
            },
            {
                model:shop,
            },
            {
                model:category,
            },
            {
                model:subcategories,
            },
            {
                model:reviews,
                include:[{
                    model:User,
                }]
            }
        ]
                }
        })
        res.status(201).json(featuredProduct);
    } catch (error) {
        console.log(error);
    }
}

//dashboard...
const getAllFeaturedProducts=async(req,res)=>{
    const {Category}=req.params;
    try {
        let featuredProduct;
        if(Category=="All"){
            featuredProduct=await featured.findAll({
                where:{status:"Featured"}, 
                 order: [['createdAt', 'DESC']], 
                include: {
                        model: Product,
                          include:[
            {
                model:image,
                where:{imagetype:"product"},
                required:false //all products may not have image
            },
            {
                model:shop,
                 include:[{
                    model:User,
                
                },
                {
                    model:image,
                },
                {
                model:category,
            },
            ]
            },
            {
                model:category,
            },
            {
                model:sale
            },
            {
                model:subcategories,
            },
            {
                model:reviews,
                include:[{
                    model:User,
                }]
            }
        ]
                    }
            })
        }
        else{
            const categoryID=await category.findOne({where:{name:Category}})
            featuredProduct=await featured.findAll({
                where:{status:"Featured",}, 
                 order: [['createdAt', 'DESC']], 
                  include: {
                        model: Product,
                         where:{categoryId:categoryID.id},
                          include:[
            {
                model:image,
                where:{imagetype:"product"},
                required:false //all products may not have image
            },
            {
                model:shop,
                 include:[{
                    model:User,
                
                },
                {
                    model:image,
                },
                {
                model:category,
            },
            ]
            },
            {
                model:sale
            },
            {
                model:category,
            },
            {
                model:subcategories,
            },
            {
                model:reviews,
                include:[{
                    model:User,
                }]
            }
        ]
                    }
            })
        }
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
            where:{status:"Requested", }, 
             order: [['createdAt', 'DESC']], 
            include: [
                {
                    model: Product,
                    include:[
            {
                model:image,
                where:{imagetype:"product"},
                required:false //all products may not have image
            },
            {
                model:shop,
            },
            {
                model:category,
            },
            {
                model:subcategories,
            },
            {
                model:reviews,
                include:[{
                    model:User,
                }]
            }
        ]
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
        console.log(id);
        const {status,expire_at}=req.body;
        const requestedFeaturedProduct=await featured.findByPk(id,{
        include: {
                    model: Product,
                    include:{
                        model: image,
                        where: { imagetype: "product" },
                        required: false
                    },
                
                }
    })

    requestedFeaturedProduct.status=status; //featured / rejected / dismissed
    requestedFeaturedProduct.expire_at=expire_at; //if featured then expire date
    requestedFeaturedProduct.save(); //save the status and expire date in the database
    
    
         const sellerId = requestedFeaturedProduct.userID; 
                 const NotificationMessage = `Your request to feature product #"${requestedFeaturedProduct.productID}" is ${status}.`;
                  if (req.io && req.userSockets) {
                     await sendNotificationToUser(req.io, req.userSockets, sellerId, NotificationMessage);
                     }

        res.status(201).json(requestedFeaturedProduct);
    } catch (error) {
        console.log(error);
    }
}

const deleteFeaturedProducts=async(req,res)=>{
    try {
        const {id}=req.params; //featuredID
       
        const requestedFeaturedProduct=await featured.findByPk(id)
        await requestedFeaturedProduct.destroy(); //delete the status and expire date in the database
    
        res.status(201).json({
            message: "Product deleted Successfully",
        });
    } catch (error) {
        console.log(error);
    }
}

export default {createProductFeatured,getAllFeaturedProducts,getAllRequestedFeaturedProducts,getUserFeaturedProducts,updateFeaturedProducts,deleteFeaturedProducts}