import shop from "../models/shopmodel.js";
import User from "../models/userModel.js";
import Product from "../models/productmodel.js";
import image from "../models/imagesModel.js";
import category from "../models/categoryModel.js";
import dotenv from "dotenv" 
dotenv.config();

const addshop = async (req, res) => {
    try {
        const { id } = req.params;
        const { shopname, shopaddress, sector, city, name } = req.body;
        const images=req.files
        // Find user
        const user = await User.findByPk(id);
        if (!user) {
            return res.status(404).json("User not found!");
        }
        //category of shop
            const [findCategory] = await category.findOrCreate({ where: { name } });
            console.log(findCategory);
            let categoryid;
            // if (!findCategory) {
            //     const newCategory = await category.create({ name });
            //     categoryid = newCategory.id;
            // }
            categoryid = findCategory.id;
        // Create shop
        const newshop = await shop.create({
            shopname, 
            shopaddress, 
            sector, 
            city, 
            categoryId:categoryid,
            userId: user.id
        });
        const entity="shop"
        const entityid = newshop.id;
            if (images && images.length > 0) {
                const imageRecords = images.map(file => ({
                    imagetype:"shop",
                    entityId:entityid,
                    imageUrl: `uploads/${entity}/${entityid}/${file.filename}`
                }));
    
                await image.bulkCreate(imageRecords);
            }
           
        res.status(201).json(newshop);
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
            where:{userId},
            include:[{
                model:image,
                where: { imagetype: 'shop' },
                required:false //all shops may not have image
            },{
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
            include:{
                model:image,
                where: { imagetype: 'shop' },
                required:false //all shops may not have image
            },
        });
        res.json(shops);
    } catch (error) {
        console.log(error);
        res.json({error:"Failed to find shops"})
    }
}

const updateshop=async(req,res)=>{  
    try {
        const {id}=req.params;
        const {shopname, shopaddress, sector, city, name}=req.body;
        const images=req.files;
        const usershop = await shop.findByPk(id);
            if (!usershop) {
                return res.status(404).json({ error: 'Shop not found!' });
            }
            const findCategory = await category.findOne({ where: { name } });
            let categoryid = findCategory ? findCategory.id : null;
            if (!findCategory) {
                const newCategory = await category.create({ name });
                categoryid = newCategory.id;
            }

            const updatedshop = await usershop.update({
                shopname: shopname || usershop.shopname,
                shopaddress: shopaddress || usershop.shopaddress,
                sector: sector || usershop.sector,
                city: city || usershop.city,
                categoryId:categoryid
            });
            const entity = "shop";
            const entityid = id;
         //   const host = process.env.NODE_ENV === 'development' ? 'http://localhost:5000' : 'http://192.168.216.179:5000';
            if (images) {
                // Remove existing shop images
                await image.destroy({
                    where: { 
                        imagetype: 'shop', 
                        entityId: id 
                    }
                });
                
                // Create new image records
                const imageRecords = images.map(file => ({
                    imagetype: entity,
                    entityId: entityid,
                    imageUrl: `${host}/uploads/${entity}/${entityid}/${file.filename}`
                }));
                
                await image.bulkCreate(imageRecords);
            }
        await usershop.update(updatedshop);
        res.json({
            message:" shop updated Successfully",
            shop: updatedshop
        })
      
    } catch (error) {
        console.log(error);
        res.json({error:" shop  FAILED TO UPDATE!"})
    }
}

const getshopName=async(req,res)=>{
    try {
        const {shopname}=req.params;
        const shops=await shop.findOne({where:{shopname},include:{
            model:image,
            where: { imagetype: 'shop' },
            required:false //all shops may not have image
        },});
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
        const category=await category.findOne({where:name});
        if(!category){
            return res.json({error:"category not Found"})
        }
        const shops=await shop.findAll({where:{categoryId:category.id},include:{
            model:image,
            where: { imagetype: 'shop' },
            required:false //all shops may not have image
        },});
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
          const shopid=shops.id;
            const products=await Product.destroy({where:{shopid}});
            if(products>0){
                console.log(`${products} Products of this shop deleted`)
            }
            // if(products.length>0){
            //     for(let i=0;i<products.length;i++){
            //         await products[i].destroy();
            //     }
            // }
            // else{
            //     console.log("No products of this shop")
            // }
           const images=await image.destroy({imagetype: 'shop',entityId:id}) ;
           if(images>0){
            console.log(`${images} Images of this shop deleted`)
        }

         await shops.destroy();
         res.json({message:"shop Deleted Successfully"});
    } catch (error) {
        console.log(error);
        res.json({error:"shop  FAILED TO DELETE!"})
    }
}

export default {addshop,getallshops,getusershop,updateshop,getshopName,getshopcategory,deleteshopbyid};