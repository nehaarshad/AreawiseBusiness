import cart from '../models/CartModel.js'
import items from '../models/cartItemModel.js'
import Product from '../models/productmodel.js'

   //on click of add to cart button
const addToCart=async(req,res)=>{
  try {
    const { userId } = req.params;
    const { productId} = req.body;
    const id=productId;
    const product=await Product.findByPk(id);
    //to find product
    if(!product){
      return res.status(404).json({ message: 'Product not found' });
    }
    //to find user cart
    const [userCart]=await cart.findOrCreate({
      where:{
        UserId:userId,
        status:'Active'  //find or create active cart for user
      }
    });

    const quantity=1;  //initial quantity of product is 1, 
    // quatity will modified when user click on + or - button only on view but send to checkout to calculate total amount
    const price=product.price*quantity;  //initialy the price the item is the price of product thar is added to cart
    const cartItem = await items.create({
              CartId: cart.id,
              productId,
              quantity,
              price
            });
    res.status(201).json(cartItem);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}

  // Get user cart with items  //CartView controller
const getCart =async (req, res) => {
    try {
      const { userId } = req.params;
      
      const userCart = await cart.findOne({
        where: {
          UserId: userId,
          status: 'Active'
        },
        include: [
          {
          model: items
          }, // Include cart items
          {
            model:Product
          } // Include product details
        ]
      });

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
      
      const cartItem = await items.findByPk(id);
      if (!cartItem) {
        return res.status(404).json({ message: 'Cart item not found' });
      }

      cartItem.quantity = quantity;
      // cartItem.price = cartItem.product.price * quantity;
      await cartItem.save();
      res.json(cartItem);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

export default { addToCart, getCart, removeCartItem, updateCartItem };

  
