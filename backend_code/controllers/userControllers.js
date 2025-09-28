import Address from "../models/addressmodel.js";
import Product from "../models/productModel.js";
import User from "../models/userModel.js";
import shop from "../models/shopmodel.js";
import Notification from "../models/notifications.js";
import image from "../models/imagesModel.js";
import bcrypt from "bcryptjs";
import path from "path";
import { fileURLToPath } from "url";
import { optimizeImage } from "../MiddleWares/uploadimage.js";
const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);
import removeImageFromDirectory from "../utils/deleteImageFromDirectory.js";
import dotenv from "dotenv";
import sale from "../models/salesModel.js";
import featured from "../models/featuredModel.js";
import { Op } from "sequelize";
import SellerPaymentAccount from "../models/sellerAccountModel.js";
import cart from "../models/CartModel.js";
dotenv.config();

//get all users
const getallusers=async(req,res)=>{
    try {
            const users=await User.findAll({
                 order: [['createdAt', 'DESC']], 
                include:{
                    model:image,
                    where: { imagetype: 'user'},
                    required:false //all users may not have image
                },
            });
            res.json(users);

    } catch (error) {
        console.log(error);
        res.json({error:"Failed to find Users"})
    }
}

//search all user by role
const getusers=async(req,res)=>{
    try {
        const {role}=req.params;
        const user=await User.findAll({ where:{role},
             order: [['createdAt', 'DESC']], 
            include:{
                model:image,
                where: { imagetype: 'user'},
                required:false //all users may not have image
            },
        });
        if (user.length === 0) {
            return res.json({ error: "No users found" });
        }
        
        res.json(user);
    } catch (error) {
        console.log(error);
        res.json({error:"User  FAILED TO FIND!"})
    }
}

//search user by username
const getuser=async(req,res)=>{
    try {
        const {username}=req.params;
        console.log(username);
        const user=await User.findAll({
            where:{username: {
                    [Op.like]:`${username}%`
                }},
            include:{
            model:image,
            where: { imagetype: 'user' },
            required:false //all users may not have image
        },});
         console.log(user)
        if(!user){
                return res.staus(404).json({ error: `Users of ${username} not found` });
        }
       
        res.json(user);
    } catch (error) {
        console.log(error);
        res.json({error:"User  FAILED TO FIND!"})
    }
}

//for profile screens
const getuserbyid=async(req,res)=>{
    try {
        const {id}=req.params;
        const user=await User.findByPk(id,{
            include:[
                {
                model:Address,
                as:"address"
            },
            {
                model:image,
                where: { imagetype: 'user' },
                required:false //all users may not have image
            },
        ]
        });
        if(!user){
            return res.json({error:"User not Found"})
        }
        res.json(user);
    } catch (error) {
        console.log(error);
        res.json({error:"User  FAILED TO FIND!"})
    }
}

const addUser = async (req, res) => {
    try {
        const { username, email, contactnumber, password, role, sector, city, address } = req.body;

        if (!username || !email || !contactnumber || !password || !role) {
            return res.json({ error: "All fields are required to be filled!" });
        }
        
        const existingUser = await User.findOne({ where: { username } });
        if (existingUser) {
            return res.json({ error: "Username already exists" });
        }
        
        const hashedPassword = await bcrypt.hash(password, 10);
        
        const newUser = await User.create({
            username,
            email,
            contactnumber,
            password: hashedPassword,
            role
        });
        
        await Address.create({ sector, city, address, userId: newUser.id });
        
        if (req.file) {
             const originalPath = req.file.path;
                            const optimizedFilename = 'optimized-' + req.file.filename;
                            const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
                            
                            // Optimize the image
                            await optimizeImage(originalPath, optimizedPath);
            const imageUrl = `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`; // Adjust the path as needed
            await image.create({ imagetype: 'user', UserId: newUser.id, imageUrl });
        }
        
        res.json({
            message: "User created successfully",
            user: newUser
        });
    } catch (error) {
        console.log(error);
        res.json({ error: "USER FAILED TO CREATE!" });
    }
}

const updateuser = async (req, res) => {
    try {
        const { id } = req.params;
        const { username, email, contactnumber, password, role, sector, city, address } = req.body;
        const user = await User.findByPk(id, {
            include: [
                {
                    model: Address,
                    as: "address"
                },
                {
                    model: image,
                    where: { imagetype: 'user',},
                    required: false
                }
            ]
        });
        
        if (!user) {
            return res.json({ error: "User not Found" });
        }
        
        const updatedUser = {
            username: username || user.username,
            email: email || user.email,
            contactnumber: contactnumber || user.contactnumber,
            role: role || user.role,
        };
        
        if (password) {
            updatedUser.password = await bcrypt.hash(password, 10);
        }
        
        await user.update(updatedUser);
            if (!user.address) {
                await Address.create({sector, city, address,userId: user.id });
                
            } else {
                const updatedAddress = {
                    sector: sector || user.address.sector,
                    city: city || user.address.city,
                    address: address || user.address.address
                };

                await user.address.update(updatedAddress);
            }
        
        
        if (req.file) {
            const userImage = await image.findOne({
                where: {  UserId: id }
            });
            if(userImage) { // Delete old image files from filesystem
                       await removeImageFromDirectory(userImage.imageUrl);
            }
             const originalPath = req.file.path;
                            const optimizedFilename = 'optimized-' + req.file.filename;
                            const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
                            
                            // Optimize the image
                            await optimizeImage(originalPath, optimizedPath);
            const imageUrl = `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`; // Adjust the path as needed
            
            if (userImage) {
                await userImage.update({ imageUrl });
            } else {
                await image.create({ imagetype: 'user', UserId: id, imageUrl });
            }
        }
        
        res.json({
            message: "User updated Successfully",
            user: updatedUser
        });
    } catch (error) {
        console.log(error);
        res.json({ error: "USER FAILED TO UPDATE!" });
    }
};

const changePassword = async (req, res) => {
    try {
        const { id } = req.params;
        const { oldPassword, newPassword } = req.body;
        console.log(req.params,req.body)
        const user = await User.findByPk(id);
        
        if (!user) {
            return res.json({ message: "User not Found" });
        }

        const checkpassword=await bcrypt.compare(oldPassword, user.password);
        
        if(!checkpassword){
        console.log(  "Password not found ",oldPassword,checkpassword)
            return res.json({ message: "Old password is incorrect" });
        }

        user.password = await bcrypt.hash(newPassword, 10);
        
        
        await user.save();
        
        console.log(  "Password changed ",
            user)
        res.json({
            message: "Password changed ",
        });
    } catch (error) {
        console.log(error);
        res.json({ error: " FAILED TO change password!" });
    }
};

const deleteuser=async(req,res)=>{
    try {
        const {id}=req.params;
        const user=await User.findByPk(id)
          if(!user){
            return res.json({error:"User not Exit"});
          } 
          const userId=user.id;
           const userImage = await image.findOne({
                where: {  UserId: id }
            });
            if(userImage){
              await removeImageFromDirectory(userImage.imageUrl);
            }
          await image.destroy({where:{imagetype:'user',UserId:user.id}});
          await Address.destroy({where:{userId}});

            const products=await Product.findAll({where:{seller:userId}}); //get all products of user
            if(products.length>0){
                for(const product of products){ //delete images of each product //delete each product's sales and featured if any
                     const productImages = await image.findAll({
                        where: { imagetype: 'product', ProductId: product.id }
                    });
                    for(const productImage of productImages){
                        if(productImage.imageUrl){
                            try {
                                await removeImageFromDirectory(productImage.imageUrl);
                            } catch (error) {
                                console.error('Error removing product image:', productImage.imageUrl, error);
                            }
                        }
                    }
                   
                }
            }

           const shops=await shop.findAll({where:{userId}});
                if(shops.length>0){
                    for(const shop of shops){ //delete images of each shop from directory
                     const shopImages = await image.findAll({
                        where: { imagetype: 'shop', ShopId: shop.id }
                    });
                    for(const shopImage of shopImages){
                        if(shopImage.imageUrl){
                            try {
                                await removeImageFromDirectory(shopImage.imageUrl);
                            } catch (error) {
                                console.error('Error removing shop image:', shopImage.imageUrl, error);
                            }
                        }
                    }
                   
                }
                
                }
                    await image.destroy({where:{imagetype:'product',ProductId:products.map(p=>p.id)}}); //delete all product images from db
                await image.destroy({where:{imagetype:'shop',ShopId:shops.map(s=>s.id)}});
            
              await SellerPaymentAccount.destroy({where:{sellerId:userId}}); 
              await Notification.destroy({where:{userId}});
              await cart.destroy({where:{UserId:userId}});
                await Product.destroy({where:{seller:userId}}); //delete all products of user
                  await shop.destroy({where:{userId}}); //delete all shops of user
              await user.destroy();
              res.json({
                 success:true,
                 message:"User Deleted Successfully"
              });

    } catch (error) {
        console.log(error);
        return res.json({error:"ERROR!"});
    }
};

const getUserNotification=async (req, res) => {
    try {
        const { id } = req.params;
        const notifications = await Notification.findAll({ where: { userId: id },
         order: [['createdAt', 'DESC']],  }
            
        );
        console.log("User notifications:", notifications);
        res.json(notifications );
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to retrieve notifications" });
    }
};



export default {getallusers,getusers,getuserbyid,getuser,addUser,updateuser,changePassword,deleteuser,getUserNotification};

