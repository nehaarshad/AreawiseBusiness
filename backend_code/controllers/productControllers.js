import Product from "../models/productModel.js";
import Shop from "../models/shopmodel.js";
import User from "../models/userModel.js";
import image from "../models/imagesModel.js";
import category from "../models/categoryModel.js";
import subcategories from "../models/subCategoryModel.js";
import reviews from "../models/reviewModel.js";
import dotenv from "dotenv";
import shop from "../models/shopmodel.js";
import { Op, where } from "sequelize";
import Day from "../models/dayModel.js";
dotenv.config();


const addproduct = async (req, res) => {
     const {id}=req.params;
    const { name, price,subtitle, description, stock,productcategory,productsubcategory} = req.body;
    console.log(req.body)
    const images=req.files
    try {
        const usershop = await Shop.findByPk(id,{where:{status:"Active"}

        });
        if (!usershop) {
            return res.status(400).json(" Shop is not Active Yet!");
        }
        const [findcategory]=await category.findOrCreate({where:{name:productcategory}});
        console.log(findcategory)//electronics
        const [findsubcategory]=await subcategories.findOrCreate({where:{name:productsubcategory,categoryId:findcategory.id}})
        console.log(findsubcategory)
        const product = await Product.create({
            name,
            price:Number(price),
            subtitle, 
            description, 
            stock:Number(stock),
            seller:usershop.userId,
            shopid:usershop.id,
            categoryId:findcategory.id,
            subcategoryId:findsubcategory.id});
        const entityid = product.id;
            if (images && images.length > 0) {
                const imageRecords = images.map(file => ({
                    imagetype:'product',
                    ProductId:entityid,
                    imageUrl: `${process.env.baseUrl}/backend_code/uploads/${file.filename}`
                }));
    
                await image.bulkCreate(imageRecords);
            }
        res.status(201).json(product);
    } catch (err) {
        res.status(500).json(err);
        console.log(err);
    }
};

const findproductbyid = async (req, res) => {
    try {
        const {id}=req.params;
        const products = await Product.findByPk(id,{
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
        });
        res.json(products);
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to find products" });
    }
};

const getallproducts = async (req, res) => {

    const {Category}= req.params;
    console.log(Category);
    try {
        let products;
        if(Category=="All"){
            products = await Product.findAll({
                 order: [['createdAt', 'DESC']], 
                include:[{
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
            });
        }
       
        else{
            const categoryID=await category.findOne({where:  { name: {
                    [Op.like]:`${Category}`
                } }})
                console.log(categoryID);
            products=await Product.findAll(
                        {where:{categoryId:categoryID.id},
                         order: [['createdAt', 'DESC']], 
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
                    
            })
            console.log(products)
        }

        res.json(products);
    } catch (error) {
        console.log(error);
    }
};

const getNewArrivalproducts = async (req, res) => {

    const {Category}= req.params;
    console.log(Category);
    try {
        let products;

        const days=await Day.findByPk(1);
 console.log("Days Record:", days);

        const dayLimit = days.day;
        const dateThreshold = new Date();
        dateThreshold.setDate(dateThreshold.getDate() - dayLimit);
console.log(dateThreshold);
        if(Category=="All"){
            products = await Product.findAll({
                where:{
                    createdAt: {
                [Op.gte]: dateThreshold 
            }
                },
                 order: [['createdAt', 'DESC']], 
                include:[{
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
            });
            console.log(products)
        }
       
        else{
        //     const categoryID=await category.findOne({
        //        where:{
        //          name: {
        //             [Op.like]:`${Category}`
        //         }},
        // })
            products=await Product.findAll(
                        {
                            where:{
                          //  categoryId:categoryID.id,
                            createdAt: {
                         [Op.gte]: dateThreshold 
            }
                        },
                         order: [['createdAt', 'DESC']], 
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
                                where:{
                 name: {
                    [Op.like]:`${Category}`
                }},
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
                    
            })
        }

        res.json(products);
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to find products" });
    }
};


const getuserproducts = async (req, res) => {
    try {
        const { id } = req.params;
        const user = await User.findByPk(id );
        if (!user) {
            return res.json({ error: "User not Found" });
        }
        const seller = user.id;
        const products = await Product.findAll({
             where: { seller } , 
              order: [['createdAt', 'DESC']], 
             include:[{
                model:image,
                where:{imagetype:"product"},
                required:false //all products may not have image
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
        if (!products) {
            return res.json({ error: "User has no products" });
        }
        res.json(products);
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to find products" });
    }
};

const getshopproducts = async (req, res) => {
    try {
        const { id } = req.params;
        const findshop = await Shop.findByPk(id);
        if (!findshop) {
            return res.json({ error: "Shop not Found" });
        }
        const shopid = findshop.id;
        const products = await Product.findAll({ 
            where: {shopid  },
             order: [['createdAt', 'DESC']], 
            include:[{
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
         });
        if (!products) {
            return res.json({ error: "Shop has no products" });
        }
        res.json(products);
    } catch (error) {
        console.log(error);
        res.json({ error: "Failed to find products" });
    }
};

const getProductByCategory = async (req, res) => {
   const {Category} = req.body;
   console.log(req.body)
   try {
       
    //    const findcategory=await category.findOne({where:{name:Category}});
    //    if (!findcategory) {
    //           return res.json({ error: "Category not Found" });
    //      }
         const categoryId = findcategory.id;
         const products = await Product.findAll({
              order: [['createdAt', 'DESC']], 
             include:[{
                 model:image,
                 where:{imagetype:"product"},
                 required:false //all products may not have image
             },
             {
                model:shop,
            },
             {
                 model:category,
                 where: { name: {
                    [Op.like]:`%${Category}%`
                } }
             },
             {
                 model:subcategories,
             },
             ,
            {
                model:reviews,
                include:[{
                    model:User,
                }]
            }
         ]
          });
         if (!products) {
             return res.json({ error: `Products of ${Category} not available` });
         }
         res.json(products);
   } catch (err) {
       res.status(500).json(err);
       console.log(err);
   }
};

const getProductByName = async (req, res) => {
   const { name } = req.params;
   console.log(req.params)
   try {

    //    const findsubcategory = await subcategories.findOne({ where: { name:name } });
    //    if (!findsubcategory) {
    //        return res.status(200).json({ error: "Subcategory not Found" });
    //    }
    //    const subcategoryId = findsubcategory.id;
       const products = await Product.findAll({
              where: {  name: {
                    [Op.like]:`${name}%`
                }},
              order: [['createdAt', 'DESC']], 
             include:[{
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
          });
         if (!products) {
             return res.json({ error: `Products of ${name} not available` });
         }
         res.json(products);
   } catch (err) {
       res.status(500).json(err);
       console.log(err);
   }
};


const updateproductArrivalDays = async (req, res) => {
    try {

        const { day } = req.body;

        let days=await Day.findByPk(1);

        if(!days){
            days=await Day.create({day}) 
        }

        days.day = day;
        await days.save()
        

        res.status(200).json({ 
            message: "Product arrival days updated successfully",
            updatedDays: days
        });

    } catch (error) {
        console.log(error);
        res.json({ error: "  FAILED TO UPDATE!" })
    }
}

const getproductArrivalDays = async (req, res) => {
    try {
        const day = await Day.findByPk(1);

        res.status(200).json(day);

    } catch (error) {
        console.log(error);
        res.json({ error: "  FAILED TO Fetch!" })
    }
}

const updateproduct = async (req, res) => {
    try {
        const {  id } = req.params;
        const { name, price,subtitle, description, stock,categories,subcategory } = req.body;
        const images=req.files
        
        const product = await Product.findByPk(id,{
            include:[{
            model:image,
            where:{imagetype:"product"},
            required:false //all products may not have image
        },
        {
            model:category,
        },
        {
            model:subcategories,
        },
    ]});
        if (!product) {
            return res.json({ error: "Product not Found" });
        }
        const [findcategory]=await category.findOrCreate({where:{name:categories}});//electronics
        const [findsubcategory]=await subcategories.findOrCreate({where:{name:subcategory,categoryId:findcategory.id}})
       
        const updatedproduct = {
            name: name || product.name,
            price: price || product.price,
            subtitle:subtitle || product.subtitle,
            description: description || product.description,
            stock: stock || product.stock,
            categoryId:  findcategory.id,
            subcategoryId: findsubcategory.id
        }
        const entity = "product";
        const entityid = id;
         if (images) {
            // Remove prvious list of product images
            await image.destroy({
                where: { 
                    imagetype: 'product', 
                    ProductId: id 
                }
            });
            
            // Re-Create or add new images 
            const imageRecords = images.map(file => ({
                imagetype: entity,
                ProductId: entityid,
                imageUrl: `${process.env.baseUrl}/backend_code/uploads/${file.filename}`
            }));
            
            await image.bulkCreate(imageRecords);
        }
        await product.update(updatedproduct);
        res.json({
            message: " product updated Successfully",
            product: updatedproduct
        })

    } catch (error) {
        console.log(error);
        res.json({ error: " product  FAILED TO UPDATE!" })
    }
}

const deleteproduct = async (req, res) => {
    try {
        const { id } = req.params;
        const product = await Product.findByPk(id);
        if (!product) {
            return res.json({ error: "Product not Exit" });
        }
        const productimage=await image.destroy({where:{imagetype:"product",ProductId:id}})
        if(productimage>0){
            console.log(`${productimage} Images of this product deleted`)
        }
        await product.destroy();
        res.json({
            message: "Product deleted Successfully",
        })
    } catch (error) {
        console.log(error);
        res.json({ error: "Product  FAILED TO DELETE!" })
    }
}

export default { addproduct,updateproductArrivalDays,getproductArrivalDays, findproductbyid,getallproducts,getuserproducts,getshopproducts,getProductByCategory,getNewArrivalproducts,getProductByName,updateproduct, deleteproduct };