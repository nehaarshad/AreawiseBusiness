import Product from "../models/productModel.js"
import sale from "../models/salesModel.js";
import shop from "../models/shopmodel.js";
import category from "../models/categoryModel.js";
import image from "../models/imagesModel.js";
import subcategories from "../models/subCategoryModel.js";
import reviews from "../models/reviewModel.js";
import User from "../models/userModel.js";
  
const addOnSale=async(req,res)=>{
try {
    const {id}=req.params; //userId
    const {discountPercent,expire_at,productId}=req.body; 
    console.log(req.params,req.body)
    const product=await Product.findByPk(productId);
       const discountOffer=discountPercent/100;  //0.25 or 0.30
       const discountPrice=product.price - (product.price * discountOffer) 
       product.onSale=true;
       await product.save();
       const onSale = await sale.create({
            expire_at,
            discount:discountPercent,
            price:discountPrice,
            userId:id,
            productId
        })

            console.log("Product On Sale created")
          return res.json(onSale)
    
} catch (error) {
    console.log(error);
    res.json({error:error})
}
}

const updateOnSaleProduct=async(req,res)=>{
    try {

        const {id}=req.params
        console.log(req.params,req.body)
        const {discountPercent,expire_at}=req.body; 
        const onSale=await sale.findByPk(id)
        if(!onSale){
            console.log("sale id not Found")
            return res.json({message:" Not Found"})
        }
        const product=await Product.findByPk(onSale.productId);
        if(!product){
            console.log("Product not Found")
            return res.json({message:"Product Not Found"})
        }
       const discountOffer=discountPercent/100;  //0.25 or 0.30
       const discountPrice=product.price - (product.price * discountOffer) 
       product.onSale=true;
       await product.save();
       const updatedData = {
            expire_at,
            discount:discountPercent,
            price:discountPrice,
            userId:onSale.userId,
            productId:product.id
        }

        await onSale.update(updatedData)
            console.log("Product On Sale updated")
          return res.json(onSale)

    } catch (error) {
        console.log(error);
        res.status(500).json({
            message:"Failed to get ADs"
        })
    }
}

const getUserSaleProducts=async(req,res)=>{
    try {
        const {id}=req.params;
        const sales = await Product.findAll({
              order: [['createdAt', 'DESC']], 
             include:[{
                model:image,
                where:{imagetype:"product"},
                required:false //all products may not have image
            },
            {
                    model:sale,
                    where:{userId:id}
                },
            {
                model:category,
            },
            {
                model:shop,
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
            });
        if(!sales){
            res.json({mesaage:"User has no items for Sale"})  
        }
        console.log("User sales",sales)
        res.status(200).json(sales)  
    } catch (error) {
        console.log(error);
        res.status(500).json({
            message:"Failed to get User ADs",
            error:error
        })
    }
}

const deleteOnSale=async(req,res)=>{
    try {
        const {id}=req.params;
        const onSale = await sale.findByPk(id);
        const productId=onSale.productId;
        const product = await Product.findByPk(productId)
        if(!product){
            console.log(`${product} not Found`)
            return res.status(404).json("Product Not Found!")
        }
        product.onSale=false
        await product.save()
        console.log(product)
        await onSale.destroy();
        res.json({
            message: "Product removed Successfully",
        })
    } catch (error) {
        console.log(error);
        res.json({error:error})
    }
}

export default {addOnSale,updateOnSaleProduct,getUserSaleProducts,deleteOnSale}