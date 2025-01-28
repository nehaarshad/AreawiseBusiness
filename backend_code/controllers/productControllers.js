import Product from "../models/productmodel.js";
import Shop from "../models/shopmodel.js";
import User from "../models/userModel.js";
import image from "../models/imagesModel.js";
import category from "../models/categoryModel.js";
import subcategories from "../models/subCategoryModel.js";


const addproduct = async (req, res) => {
     const {id}=req.params;
    const { name, price, description, stock,productcategory,productsubcategory} = req.body;
    const images=req.files
    try {
        const usershop = await Shop.findByPk(id);
        if (!usershop) {
            return res.status(400).json(" Shop not Found");
        }
        const [findcategory]=await category.findOrCreate({where:{name:productcategory}});
        console.log(findcategory)//electronics
        const [findsubcategory]=await subcategories.findOrCreate({where:{name:productsubcategory,categoryId:findcategory.id}})
        console.log(findsubcategory)
        const product = await Product.create({name, price, description, stock,seller:usershop.userId,shopid:usershop.id,categoryId:findcategory.id,subcategoryId:findsubcategory.id});
        const entityid = product.id;
            if (images && images.length > 0) {
                const imageRecords = images.map(file => ({
                    imagetype:"product",
                    entityId:entityid,
                    imageUrl: `http://localhost:5000/backend_code/uploads/${file.filename}`
                }));
    
                await image.bulkCreate(imageRecords);
            }
        res.status(201).json(product);
    } catch (err) {
        res.status(500).json(err);
        console.log(err);
    }
};

const getallproducts = async (req, res) => {
    try {
        const products = await Product.findAll({
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
        ]
        });
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

const updateproduct = async (req, res) => {
    try {
        const {  id } = req.params;
        const { name, price, description, stock,categories,subcategory } = req.body;
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
            description: description || product.description,
            stock: stock || product.stock,
            categoryId:  findcategory.id,
            subcategoryId: findsubcategory.id
        }
        const entity = "product";
        const entityid = id;
         if (images) {
            // Remove existing product images
            await image.destroy({
                where: { 
                    imagetype: 'product', 
                    entityId: id 
                }
            });
            
            // Create new image records
            const imageRecords = images.map(file => ({
                imagetype: entity,
                entityId: entityid,
                imageUrl: `http://localhost:5000/backend_code/uploads/${file.filename}`
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
        const productimage=await image.destroy({where:{imagetype:"product",entityId:id}})
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

export default { addproduct, getallproducts,getuserproducts,getshopproducts,updateproduct, deleteproduct };