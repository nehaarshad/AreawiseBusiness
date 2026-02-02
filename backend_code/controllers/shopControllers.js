import shop from "../models/shopmodel.js";
import User from "../models/userModel.js";
import Product from "../models/productModel.js";
import image from "../models/imagesModel.js";
import category from "../models/categoryModel.js";
import SellerPaymentAccount from "../models/sellerAccountModel.js";
import review from "../models/reviewModel.js";
import dotenv from "dotenv" 
import sendNotificationToUser from "../utils/sendNotification.js";
import { Op } from "sequelize";
import sale from "../models/salesModel.js";
import featured from "../models/featuredModel.js";
import path from "path";
import { fileURLToPath } from "url";
import { optimizeImage } from "../MiddleWares/uploadimage.js";
import fs from "fs";
const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);
dotenv.config();
import removeImageFromDirectory from "../utils/deleteImageFromDirectory.js";

const addshop = async (req, res) => {
    try {
        const { id } = req.params;
        const { shopname, shopaddress,deliveryPrice, sector, city, name } = req.body;
        const images=req.files
        // Find user
        const user = await User.findByPk(id);
        if (!user) {
            return res.status(404).json("Try Later!");
        }
        // Find userAccount
        const userAccount = await SellerPaymentAccount.findOne({ where: { sellerId:id } });
        if (!userAccount) {
             console.log("User account not found!");
         return res.json( "A payment account is required to receive online transactions. Please add one to continue." );
        }

        //category of shop
            const [findCategory] = await category.findOrCreate({ where: { name } });
            console.log(findCategory);
            let categoryid;
            categoryid = findCategory.id;
        // Create shop
        const newshop = await shop.create({
            shopname, 
            shopaddress, 
            sector, 
            city, 
            status:'Processing...',
            deliveryPrice,
            categoryId:categoryid,
            userId: user.id
        });
                 if (images && images.length > 0) {
            const imageRecords = [];
            
            // Process each image with optimization
            for (const file of images) {
                try {
                    const originalPath = file.path;
                    const optimizedFilename = 'optimized-' + file.filename;
                    const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
                    
                    // Optimize the image
                    await optimizeImage(originalPath, optimizedPath);
                    imageRecords.push({
                         imagetype:'shop',
                    ShopId:newshop.id,
                    imageUrl: `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`
                    });
                    
                } catch (imageError) {
                    console.error('Error processing image:', file.filename, imageError);
                    continue;
                }
            }

            if (imageRecords.length > 0) {
                await image.bulkCreate(imageRecords);
            }
        }
            
           const sellerId = id; 
           const notificationMessage = `Your new shop "${newshop.shopname || 'Shop'}" has been created.`;

           if (req.io && req.userSockets) {
               await sendNotificationToUser(req.io, req.userSockets, sellerId, notificationMessage);
                const admins = await User.findAll({where:{role:'Admin'}}); 
           const adminNotificationMessage = `A new request to add "${newshop.shopname || 'Shop'}" Shop in the app. Please review and approve.`;

           for(const admin of admins){
              if (req.io && req.userSockets) {
               await sendNotificationToUser(req.io, req.userSockets, admin.id, adminNotificationMessage); //adminId
           }
           }

           }

        res.status(201).json("Shop Added Successfully!");
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};

const getusershop=async(req,res)=>{
    try {
        const {id}=req.params;
        const user=await User.findByPk(id);
        if(!user){
            return res.json({error:"User not Found"})
        }
        const userId=user.id;
        const usershop=await shop.findAll({
             order: [['createdAt', 'DESC']], 
            where:{userId},
            include:[{
                model:image,
                where: { imagetype: 'shop' },
                 attributes: ['imageUrl'] ,
                required:false //all shops may not have image
            },
            {
                model:User,
                required:true //all shops may  have category
            },
            {
                model:category,
                required:true //all shops may  have category
            },
        ]});
        if(!usershop){
            return res.json({error:"shop not Found"})
        }
        res.json(usershop);
    } catch (error) {
        console.log(error);
        res.json({error:"shop  FAILED TO FIND!"})
    }
}
//list view of all shops
const getallshops=async(req,res)=>{
    try {
        const shops=await shop.findAll({
             order: [['createdAt', 'DESC']], 
            include:[{
                model:image,
                where: { imagetype: 'shop' },
                  attributes: ['imageUrl'] ,
                required:false //all shops may not have image
            },
            {
                model:User,
                required:true //all shops may  have category
            },
            {
                model:category,
                required:true //all shops may  have category
            },
        ]
        });
        res.json(shops);
    } catch (error) {
        console.log(error);
        res.json({error:"Failed to find shops"})
    }
}

const getShopByName=async(req,res)=>{
    const { name } = req.params;
   console.log(name)
   try {

       const searchResults = await shop.findAll({
              where: { shopname: {
                    [Op.like]:`${name}%`
                } },
             include:[{
                  attributes: ['imageUrl'] ,
                model:image,
                where: { imagetype: 'shop' },
                required:false //all shops may not have image
            },
            {
                model:User,
                required:true //all shops may  have category
            },
            {
                model:category,
                required:true //all shops may  have category
            },
        ]
          });
        console.log(searchResults);
         res.json(searchResults);
   } catch (err) {
       res.status(500).json(err);
       console.log(err);
   }
}

const updateshop=async(req,res)=>{  
    try {
        const {id}=req.params;
        const {shopname, shopaddress,deliveryPrice, sector, city, name}=req.body;
        const images=req.files;
        const usershop = await shop.findByPk(id,{
            include:[
                {
            model:image,
            where:{imagetype:"shop"},
              attributes: ['imageUrl'] ,
            required:false 
        },
        {
            model:category,
        },]});
            if (!usershop) {
                return res.status(404).json({ error: 'Shop not found!' });
            }
            const [findcategory]=await category.findOrCreate({where:{name}});//electronics
    
            const updatedshop = {
                shopname: shopname || usershop.shopname,
                shopaddress: shopaddress || usershop.shopaddress,
                sector: sector || usershop.sector,
                city: city || usershop.city,
                deliveryPrice:deliveryPrice||usershop.deliveryPrice,
                categoryId:findcategory.id
            };
           
           if (images && images.length > 0) {
            // Remove previous images
            const oldImages = await image.findAll({
                where: { imagetype: 'shop', ShopId: id }
            });

            // Delete old image files from filesystem
            for (const oldImage of oldImages) {
                try {
                    const oldPath = path.join(dirname, '..', 'uploads', path.basename(oldImage.imageUrl));
                    if (fs.existsSync(oldPath)) {
                        fs.unlinkSync(oldPath);
                    }
                } catch (deleteError) {
                    console.error('Error deleting old image files:', deleteError);
                }
            }

            await image.destroy({
                where: { imagetype: 'shop', ShopId: id }
            });

            // Process new images
            const imageRecords = [];
            for (const file of images) {
                try {
                    const originalPath = file.path;
                    const optimizedFilename = 'optimized-' + file.filename;
                    const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
                    
                    // Optimize the image
                    await optimizeImage(originalPath, optimizedPath);
                    
                    imageRecords.push({
                        imagetype: 'shop',
                        ShopId: id,
                        imageUrl: `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`,
                     });
                    
                } catch (imageError) {
                    console.error('Error processing image during update:', file.filename, imageError);
                    continue;
                }
            }

            if (imageRecords.length > 0) {
                await image.bulkCreate(imageRecords);
            }
        }

          await usershop.update(updatedshop);

           const sellerId = usershop.userId; 
           const notificationMessage = `Your shop has been updated.`;

           if (req.io && req.userSockets) {
               await sendNotificationToUser(req.io, req.userSockets, sellerId, notificationMessage);
           }

        res.json({
            success:true,
            message:" shop updated Successfully",
            shop: updatedshop
        })
      
    } catch (error) {
        console.log(error);
        res.json({error:" shop  FAILED TO UPDATE!"})
    }
}

const updateShopStatus=async(req,res)=>{  
    try {
        const {id}=req.params;
        const {status}=req.body;
        const usershop = await shop.findByPk(id,{
          include: [{
            model: User,
          }]
          });
            if (!usershop) {
                return res.status(404).json({ error: 'Shop not found!' });
            }

            const oldStatus = usershop.status;
            
            const updatedshop = {
                status: status || usershop.status,
            };

             await usershop.update(updatedshop);

            // Send notification to the shop owner (seller)
             const sellerId = usershop.userId; 
             const notificationMessage = `Your shop ${usershop.shopname} status has been updated to "${status}" by admin`;
    
             if (req.io && req.userSockets) {
             await sendNotificationToUser(req.io, req.userSockets, sellerId, notificationMessage);
             }

         
        res.json({
            success:true,
            message:" shop updated Successfully",
            shop: updatedshop
        })
      
    } catch (error) {
        console.log(error);
        res.json({error:" shop  FAILED TO UPDATE!"})
    }
}

const getshopId=async(req,res)=>{
    try {
        const {id}=req.params;
        const shops=await shop.findByPk(id,{
            include:[{
                model:image,
                where: { imagetype: 'shop' },
                  attributes: ['imageUrl'] ,
                required:false //all shops may not have image
            },
            {
                model:User,
                required:true //all shops may  have category
            },
            {
                model:category,
                required:true //all shops may  have category
            },
        ]});
        if(!shops){
            return res.json({error:"shop not Found"})
        }
        res.json(shops);
    } catch (error) {
        console.log(error);
        res.json({error:"shop  FAILED TO FIND!"})
    }
}

const getshopcategory=async(req,res)=>{
    try {
        const {name}=req.params;
        const findcategory=await category.findOne({where:name});
        if(!findcategory){
            return res.json({error:"category not Found"})
        }
        const shops=await shop.findAll({where:{categoryId:category.id},
            include:[{
                model:image,
                  attributes: ['imageUrl'] ,
                where: { imagetype: 'shop' },
                required:false //all shops may not have image
            },
            {
                model:User,
                required:true //all shops may  have category
            },
            {
                model:category,
                required:true //all shops may  have category
            },
        ]});
        if(!shops){
            return res.json({error:"shop not Found"})
        }
        res.json(shops);
    }
    catch (error) {
        console.log(error);
        res.json({error:"shop  FAILED TO FIND!"})
    }
}

const deleteshopbyid=async(req,res)=>{
    try {
        const {id}=req.params;
        const shops=await shop.findByPk(id);
          if(!shops){
            return res.json({error:"shop not Exit"});
          } 
           const shopImages = await image.findAll({
                                  where: { imagetype: 'shop', ShopId: shops.id }
                              });
                              for(const shopImage of shopImages){
                                    await removeImageFromDirectory(shopImage.imageUrl);
                              }
           const sellerId = shops.userId; 
          const shopid=shops.id;
          const products=await Product.findAll({where:{shopid}});
            if(products.length>0){
                for(const product of products){

                     const productImages = await image.findAll({
                       where: { imagetype: 'product', ProductId: product.id }
                    });
                    for(const productImage of productImages){
                        try {
                            await removeImageFromDirectory(productImage.imageUrl);
                        } catch (error) {
                            console.log(error);
                        }
                    }                          
             }
            }

            
              //review images deletion
                 const  reviews=await review.findAll({where:{productId:products.map(p=>p.id)}});
            if(reviews.length>0){
                     const reviewImages = await image.findAll({
                       where: { imagetype: 'reviews', reviewId: reviews.map(r=>r.id) }
                    });
                    for(const Image of reviewImages){
                        try {
                            await removeImageFromDirectory(Image.imageUrl);
                        } catch (error) {
                            console.log(error);
                        }
                    }

                
                }
               await image.destroy({where:{imagetype:'reviews',reviewId:reviews.map(r=>r.id)}});
           await review.destroy({where:{productId:products.map(p=>p.id)}});
           await image.destroy({where:{imagetype:'product',ProductId:products.map(p=>p.id)}});
            await sale.destroy({where:{productId:products.map(p=>p.id)}});
                await featured.destroy({where:{productID:products.map(p=>p.id)}});
            await Product.destroy({where:{shopid}});
           await image.destroy({where:{imagetype: 'shop',ShopId:id}}) ;

            await shops.destroy();
           const notificationMessage = `Your shop has been deleted.`;

           if (req.io && req.userSockets) {
               await sendNotificationToUser(req.io, req.userSockets, sellerId, notificationMessage);
           }
         res.json({message:"shop Deleted Successfully"});
    } catch (error) {
        console.log(error);
        res.json({error:"shop  FAILED TO DELETE!"})
    }
}

export default {addshop,getallshops,getusershop,updateshop,updateShopStatus,getshopId,getshopcategory,deleteshopbyid,getShopByName};