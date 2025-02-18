import cart from '../models/CartModel.js'
import items from '../models/cartItemModel.js'
import Product from '../models/productmodel.js'
import order from '../models/orderModel.js'
import Address from '../models/addressmodel.js'
import image from "../models/imagesModel.js";


//onCheckoutButtonClick
const ViewCheckout = async (req, res) => {
  try {
      const { id } = req.params;  // id of cart to be checked out

      // Fetch the cart with its associated CartItems, Product, and image
      const userCart = await cart.findByPk(id, {
          include: [
              {
                  model: items,
                  as: 'CartItems',
                  include: [
                      {
                          model: Product,
                          include: {
                              model: image,
                              where: { imagetype: "product" },
                              required: false
                          }
                      }
                  ]
              }
          ]
      });

      if (!userCart) {
          return res.json({ message: 'No cart found' });
      }

      // Check for existing pending order of this cart
      const existingCart = await order.findOne({
          where: {
              cartId: id,
              status: 'Pending'
          }
      });

      if (existingCart) {
          await userCart.update({ status: 'Active' });
          await existingCart.destroy();
      }

      console.log('User Cart:', JSON.stringify(userCart, null, 2));

      // Check if CartItems exist
      if (!userCart.CartItems || userCart.CartItems.length === 0) {
          return res.json({ message: 'No items found in the cart' });
      }

      let discount = 0.1; // 10% discount
      let shippingPrice = 120;
      let total = 0;

      // Calculate the total price of items in the cart
      userCart.CartItems.forEach(item => {
          total += item.price;
      });

      if(total>5000){
      total = total - (total * discount) + shippingPrice;
      }
      else{
      total = total + shippingPrice;
      }

      // Create the order
      const newOrder = await order.create({
          cartId: userCart.id,
          addressId: 1,  // by default address id is 1 randomly but can be set when user places order
          total: total,
          discount: 0.1,
          shippingPrice: 120,
          status: 'Pending' // Initial status of the order
      });

      // Update the cart status to 'Ordered'
      await userCart.update({ status: 'Ordered' });

      // Fetch the newly created order with its associated cart, CartItems, Product, and image
      const ordered = await order.findByPk(newOrder.id, {
          include: [
              {
                  model: cart,
                  as: 'Cart',
                  include: [
                      {
                          model: items,
                          as: 'CartItems',
                          include: [
                              {
                                  model: Product,
                                  include: {
                                      model: image,
                                      where: { imagetype: "product" },
                                      required: false
                                  }
                              }
                          ]
                      }
                  ]
              }
          ]
      });

      // Return the order details to the client
      res.status(201).json(ordered);
  } catch (error) {
      res.status(500).json({ message: error.message });
  }
};
  //checkout to create order->next passed cartid... to address view where order button have this controller

//onPlaceOrderButtonClick
const PlaceOrder=async(req,res)=>{
    try {
    //  const { id } = req.params;  //id of order to be placed
      const { cartId,sector,city,address } = req.body; //address of user where order is to be delivered
      const userCart = await order.findOne({   //
        where: {
          cartId,
          status: 'Pending'
        },
        include: [
          {
          model: items,
          include: [
            {
              model: Product,
                include:{
                    model:image,
                    where:{imagetype:"product"},
                    required:false //all products may not have image
                },
          }], // Include product details
          },]
      });
      const userId = userCart.UserId;
      const location = await Address.findOne({ where: { userId } });  
      if (location) {
        const updatedAddress = {
          address:address || location.address,
          city  :city || location.city,
          sector : sector || location.sector,
          userId: userId
          }
          await location.update(updatedAddress);  //if user has already set address then update it
      }
      else{
      location=  await Address.create({sector, city, address,userId: userId }); //if user has not set address then create new address
      }
      const placedOrder = await userCart.update({ status: 'send' });  //update the status of order to placed
      res.status(201).json(placedOrder);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }


  export default {ViewCheckout,PlaceOrder}