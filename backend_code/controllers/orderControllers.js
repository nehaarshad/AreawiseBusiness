import cart from '../models/CartModel.js'
import items from '../models/cartItemModel.js'
import Product from '../models/productmodel.js'
import order from '../models/orderModel.js'
import Address from '../models/addressmodel.js'


//onCheckoutButtonClick
const ViewCheckout=async(req,res)=>{
    try {
      const { id } = req.params;  //id of cart to be checked out

      //once user click on checkout button order created to view total price, 
        // if user click on order button PlaceOrder controlller called ,
        // if click on cancel button to modify the cart and again click on checkout button then previously created order of similar cart is deleted
         
        const existingCart = await order.findOne({   //
          where: {
            cartId: id,
            status: 'Pending'
          } });
          if(existingCart){
            await userCart.update({ status: 'Active' });
             await existingCart.destroy();
          }

      const userCart = await cart.findOne({
        where: {
          id,
     //     UserId: userId,
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
      let total = 0;
      userCart.items.forEach(item => {
          total += item.price * item.quantity;  //quantity of each item in cart multiplied by price of each item, quantity is initilly 1 , but can be modified by user
      });

             // Create the order
        const newOrder = await order.create({
          cartId: userCart.id,
          addressId: 1,  //by default address id is 1 randomly but can be set when user place order a
          total: total,
          status: 'Pending' // Initial status of the order
      });

      // Update the cart status to 'Ordered'
      await userCart.update({ status: 'Ordered' });

      // Return the order details to the client
      res.status(201).json({
          message: 'Order placed successfully',
          order: newOrder
      });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

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
          model: items
          }, 
          {
            model:Product
          } 
        ]
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