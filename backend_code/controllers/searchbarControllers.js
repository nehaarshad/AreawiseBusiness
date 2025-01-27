import User from "../models/userModel.js";
import Product from "../models/productmodel.js";
import Shop from "../models/shopmodel.js";

//by location
//by category
//by shopname
//by productname
//by subcategory
//by sellername

const searchProductbylocation = async (req, res) => {
    const { sector } = req.params;
    try {
        const shops = await Shop.findAll({where: { sector }});
        if (!shops.length) {
            return res.json({ error: `No Shops found in ${sector}` });
        }

        const products = [];
        //product of each shop
        for (let i = 0; i < shops.length; i++) {
            const shop = shops[i].id;
            const shopProducts = await Product.findAll({ 
                where: { shop },
                // include: [
                //     {
                //         model: Shop,
                //         as: 'shop'
                //     },
                //     {
                //         model: User,
                //         as: 'user'
                //     }
                // ]
                });

            if (!shopProducts.length) {
                // return res.json({ error: `No Products found in Shop ${shops[i].shopname}` });
                 continue;  //skip this shop and move to next shop
            }

            for (let j = 0; j < shopProducts.length; j++) {
               // const product = shopProducts[j];
                // const productdetails = {
                //     id: product.id,
                //     name: product.name,
                //     price: product.price,
                //     description: product.description,
                //     imageUrl: product.imageUrl,
                //     stock: product.stock,
                //     category: product.category,
                //     subcategory: product.subcategory,
                //     shop: {
                //         shopname: product.shop.shopname,
                //         city: product.shop.city,
                //         sector: product.shop.sector,
                //         shopaddress: product.shop.shopaddress,
                //         category: product.shop.category
                //     },
                //     user: {
                //         username: product.user.username,
                //         email: product.user.email,
                //         contactnumber: product.user.contactnumber
                //     }
                // };
                const productdetails = shopProducts.map(product => ({
                    id: product[j].id,
                    name: product[j].name,
                    price: product[j].price,
                    description: product[j].description,
                    imageUrl: product[j].imageUrl,
                    stock: product[j].stock,
                    category: product[j].category,
                    subcategory: product[j].subcategory,
                    // shop: product[j].shop.map(shop => ({
                    //     shopname: shop.shopname,
                    //     city: shop.city,
                    //     sector: shop.sector,
                    //     shopaddress: shop.shopaddress,
                    //     category: shop.category,
                    // })),
                    // seller: product[j].user.map(user => ({
                    //     username: user.username,
                    //     email: user.email,
                    //     contactnumber: user.contactnumber,
                    //     role: user.role
                    // }))
               }));
                products.push(productdetails);

                // const info=userdata.map(user=>({
                //     userid :user.userid ,
                //     username:user.username,
                //     email:user.email,
                //     createdAt:user.createdAt,
                //     updatedAt:user.updatedAt,
                //     blogs: user.UserBlogs.map(blog=>({
                //         blogid:blog.blogid,
                //         blogtitle:blog.blogtitle,
                //         blogcontent:blog.blogcontent,
                //         createdAt:blog.createdAt,
                //         userId:blog.userId,
                //         updatedAt:blog.updatedAt,
                //         comments:blog.BlogComments.map(com=>({
                //             id:com.id,
                //             title:com.title,
                //             content:com.content,
                //             bId :com.bId ,
                //             uId:com.uId,
                //             createdAt:com.createdAt,
                //             updatedAt:com.updatedAt	
                //         }))
                //     }))
                // }))
        }
        } 
        if (!products.length) {
            return res.json({ error: `No Products found in ${sector}` });
        }
        res.json(products);
        }catch (error) {
        console.log(error);
        res.json({ error: `Failed to find Products in ${sector}` });
         }
}

const searchProductbycategory = async (req, res) => {
    const { category } = req.params;
    try {
        const products = await Product.findAll({ where: { category } });
        if (!products) {
            return res.json({ error: `No Products found in ${category}` });
        }
        res.json(products);
    } catch (error) {
        console.log(error);
        res.json({ error: `Failed to find Products in ${category}` });
    }
}

const searchProductbyshopname = async (req, res) => {
    const { shopname } = req.params;
    try {
        const shops = await Shop.findOne({ where: { shopname } });
        if (!shops) {
            return res.json({ error: `No Shop found with name ${shopname}` });
        }
        const shop = shops.id;
        const products = await Product.findAll({ where: { shop } });
        res.json(products);
    }
    catch (error) {
        console.log(error);
        res.json({ error: `Failed to find Products in ${shopname}` });
    }
}

const searchProductbyproductname = async (req, res) => {
    const { name } = req.params;
    try {
        const products = await Product.findAll({ where: { name } });
        if (!products) {
            return res.json({ error: `No Products found with name ${name}` });
        }
        res.json(products);
    } catch (error) {
        console.log(error);
        res.json({ error: `Failed to find Products with name ${name}` });
    }
}

const searchProductbysubcategory = async (req, res) => {
    const { subcategory } = req.params;
    try {
        const products = await Product.findAll({ where: { subcategory } });
        if (!products) {
            return res.json({ error: `No Products found in ${subcategory}` });
        }
        res.json(products);
    } catch (error) {
        console.log(error);
        res.json({ error: `Failed to find Products in ${subcategory}` });
    }
}

const searchProductbysellername = async (req, res) => {
    const { sellername } = req.params;
    try {
        const user = await User.findOne({ where: { username: sellername } });
        if (!user) {
            return res.json({ error: `No Seller found with name ${sellername}` });
        }
        const userId = user.id;
        const shop = await Shop.findOne({ where: { userId } });
        if (!shop) {
            return res.json({ error: `No Shop found for ${sellername}` });
        }
        const shopId = shop.id;
        const products = await Product.findAll({ where: { shopId } });
        res.json(products);
    }
    catch (error) {
        console.log(error);
        res.json({ error: `Failed to find Products for ${sellername}` });
    }
}

export { searchProductbylocation, searchProductbycategory, searchProductbyshopname, searchProductbyproductname, searchProductbysubcategory, searchProductbysellername };


