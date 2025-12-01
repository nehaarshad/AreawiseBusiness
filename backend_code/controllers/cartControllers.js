import cart from '../models/CartModel.js'
import items from '../models/cartItemModel.js'
import Product from '../models/productModel.js';
import image from "../models/imagesModel.js";
import User from '../models/userModel.js';
import sale from '../models/salesModel.js';
import shop from '../models/shopmodel.js';

   //on click of add to cart button
const addToCart=async(req,res)=>{
  try {
    const { id } = req.params;
    console.log(id)
    const { productId,quantity} = req.body;
    console.log('Received productId: and quantity', productId,quantity);
    const user = await User.findByPk(id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    const product=await Product.findByPk(productId,
      {
        include:[{
            model:image,
            where:{imagetype:"product"},
            required:false //all products may not have image
        },
        {
          model:sale
        },
        {
          model:shop
        }
      ]
    });
    //to find product
    if(!product){
      return res.status(404).json({ message: 'Product not found' });
    }

    console.log('Product found:', product);
    let productPrice;
    console.log('Product is Onsale:', product.onSale);
    if(product.onSale){
      productPrice = product.saleOffer.price;
    }
    else{
    productPrice = product.price;
    }
    console.log('Product Price:', productPrice);
    productPrice = productPrice + product.shop.deliveryPrice;

    console.log('Product Price after adding deliveryCharges:', productPrice);
    console.log('params:', id, productId);
    //to find user cart
    const [userCart]=await cart.findOrCreate({
      where:{
        UserId:id,
        status:'Active'  //find or create active cart for user
      }
    });
    console.log('userCart:', userCart);
   
      // Check if product already exists in cart
    const existingItem = await items.findOne({
      where: {
        cartId: userCart.id,
        productId: productId
      }
    });

    console.log('search cart item:', existingItem);
    if (existingItem) {
      // Update existing item
      existingItem.quantity += quantity;
      existingItem.price = productPrice * existingItem.quantity;
      product.onCartCounts += existingItem.quantity;
      await product.save();
      await existingItem.save();
      console.log('update cart item:', existingItem);
      return res.json(existingItem);
    }

    const price=productPrice*quantity;
    const status ="pending"
    const sellerId= product.seller;
    const shippingPrice= product.shop.deliveryPrice;
    const cartItem = await items.create({
              cartId: userCart.id,
              productId,
              quantity,
              status,
              sellerId,
              shippingPrice,
              price
            });

    product.onCartCounts += quantity;
    await product.save();
    console.log('new cart item:', cartItem);        
    res.status(201).json(cartItem);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
}
  // Get user cart with items  //CartView controller
const getCart =async (req, res) => {
    try {
      const { id } = req.params;
      
      const userCart = await cart.findOne({
        where: {
          UserId: id,
          status: 'Active'
        },
        include: [
          {
          model: items,
           order: [['createdAt', 'DESC']], 
          include: [
            {
              model: Product,
                include:[{
                    model:image,
                    where:{imagetype:"product"},
                    required:false //all products may not have image
                },
                {
                  model:sale
                },
                {
                  model:shop
                }
              ],
          }], // Include product details
          },]
      })

      if (!userCart) {
        return res.json({ message: 'No active cart found' });
      }

      res.json(userCart);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
}
   // Remove item from cart
const removeCartItem = async(req, res) => {
    try {
      const { id } = req.params;
      
      const cartItem = await items.findByPk(id);
      if (!cartItem) {
        return res.status(404).json({ message: 'Cart item not found' });
      }
      const product = await Product.findByPk(cartItem.productId);
      if (product) {
        product.onCartCounts -= cartItem.quantity;
        await product.save();
      }
      await cartItem.destroy();
      res.json({status:200, message: 'Item removed from cart' });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
}
    // controller for + and - button on cart view,   update only quantity instead of price
const updateCartItem = async(req, res) => {
    try {
      const { id } = req.params;
      const { quantity } = req.body;
      
      const cartItem = await items.findByPk(id,{
        include: [
          { model: Product, 
            include:[{
              model:image,
              where:{imagetype:"product"},
              required:false //all products may not have image
          },
          {
            model:sale
          },
          {
            model:shop
          }
        ],
          }]
      });
      if (!cartItem) {
        return res.status(404).json({ message: 'Cart item not found' });
      }

      console.log("item",cartItem);

     const oldQuantity = cartItem.quantity;
      const quantityDifference = quantity - oldQuantity; //2-1=1 || 1-2=-1
      cartItem.quantity = quantity;
       let productPrice;
    console.log('Product is Onsale:', cartItem.product.onSale);
    if(cartItem.product.onSale){
      productPrice = cartItem.product.saleOffer.price;
    }
    else{
    productPrice = cartItem.product.price;
    }
    console.log('Product Price:', productPrice);
    productPrice = productPrice + cartItem.product.shop.deliveryPrice;
      cartItem.price = productPrice * quantity;
      console.log('Updated cart item:', cartItem.quantity, cartItem.price);
      const product = await Product.findByPk(cartItem.productId);
      if (product) {
        product.onCartCounts += quantityDifference; // += 1 || += -1
        await product.save();
      }
      await cartItem.save();
      res.json(cartItem);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
}
 //on back or close button
const updateCart = async(req, res) => {
  try {
    const { id } = req.params;  //id of cart item to be updated
    
    const userCart = await cart.findByPk(id,{
      include: [
        {
        model: items,
        include: [
          {
            model: Product,
              include:{
                  model:image,
                  where:{
                    imagetype:"product"
                  },
                  required:false //all products may not have image
              },
        }], // Include product details
        },]
    });
    if (!userCart) {
      return res.status(404).json({ message: 'Cart not found' });
    }
    await userCart.update({ status: 'Active' });
    await userCart.save();
    res.json(userCart);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}

const deleteUserCart = async(req, res) => {
  try {
    //provide id of cart to be deleted
    const { id } = req.params;
    
    const userCart = await cart.findByPk(id);
    if (!userCart) {
      return res.status(404).json({ message: 'Cart not found' });
    }
    const cartItems = await items.findAll({ where: { cartId: id } });
    await userCart.destroy();
    res.json({status:200, message: 'User Cart Deleted!' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}

export default { addToCart, getCart, removeCartItem, updateCartItem ,updateCart,deleteUserCart};

  
