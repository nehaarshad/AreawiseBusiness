import Address from "../models/addressmodel.js";
import Product from "../models/productmodel.js";
import User from "../models/userModel.js";
import shop from "../models/shopmodel.js";
import image from "../models/imagesModel.js";
import bcrypt from "bcryptjs";

//get all users
const getallusers=async(req,res)=>{
    try {
            const users=await User.findAll({
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
        const user=await User.findOne({
            where:{username},
            include:{
            model:image,
            where: { imagetype: 'user' },
            required:false //all users may not have image
        },});
        if(!user){
            return res.json({error:"User not Found"})
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
            const imageUrl = `http://192.168.169.179:5000/backend_code/uploads/${req.file.filename}`; // Adjust the path as needed
            
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


const deleteuser=async(req,res)=>{
    try {
        const {id}=req.params;
        const user=await User.findByPk(id)
          if(!user){
            return res.json({error:"User not Exit"});
          } 
          const userId=user.id;
          const userimage=await image.destroy({where:{imagetype:'user',UserId:user.id}});
            if(userimage>0){
                console.log(`${userimage} images of this user is deleted`)
            }
          const useraddress=await Address.destroy({where:{userId}});
            if(useraddress>0){
                console.log(`${useraddress} adddress of this user is deleted`)
             }
            const products=await Product.destroy({where:{seller:userId}});
            if(products>0){
                console.log(`${products} Products of this shop deleted`)
            }
           const shops=await shop.destroy({where:{userId}});
                if(shops>0){
                    console.log(`${shops} shops of this user is deleted`)
                }
               
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

export default {getallusers,getusers,getuserbyid,getuser,updateuser,deleteuser};

