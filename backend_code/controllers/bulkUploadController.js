import InitialProduct from "../models/initialProducts.js";
import Shop from "../models/shopmodel.js";

const addinitproduct = async (req, res) => {
     const {id}=req.params;
    const { name, price,subtitle, description,condition, stock,productcategory,productsubcategory} = req.body;
    console.log(req.body)
    try {
        const usershop = await Shop.findByPk(id,{where:{status:"Active"}

        });
        if (!usershop) {
            return res.status(400).json(" Shop is not Active Yet!");
        }
        // const [findcategory]=await category.findOrCreate({where:{name:productcategory}});
        // console.log(findcategory)//electronics
        // const [findsubcategory]=await subcategories.findOrCreate({where:{name:productsubcategory,categoryId:findcategory.id}})
        // console.log(findsubcategory)
        const product = await InitialProduct.create({
            name,
            price:Number(price),
            subtitle, 
            onSale:false,
            description, 
            condition,
            stock:Number(stock),
            seller:usershop.userId,
            shopid:usershop.id,
           });

        res.status(201).json(product);


    } catch (err) {
        res.status(500).json(err);
        console.log(err);
    }
};

export default {addinitproduct}