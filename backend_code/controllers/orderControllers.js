import cart from '../models/CartModel.js'
import items from '../models/cartItemModel.js'
import Product from '../models/productModel.js'
import order from '../models/orderModel.js'
import Address from '../models/addressmodel.js'
import image from "../models/imagesModel.js";
import SellerOrder from '../models/sellerOrderModel.js'


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
    //   const existingCart = await order.findOne({
    //       where: {
    //           cartId: id,
    //           status: 'Pending'
    //       }
    //   });

    //   if (existingCart) {
    //       await userCart.update({ status: 'Active' });
    //       await existingCart.destroy();
    //   }

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
          status: 'InComplete' // Initial status of the order
      });

      // Update the cart status to 'Ordered'
   //   await userCart.update({ status: 'Ordered' });

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
// const PlaceOrder = async (req, res) => {
//     try {
//         const { cartId, sector, city, address } = req.body;

//         console.log('cartId from request:', cartId);
//         // Find the order with cart details
//         const userOrder = await order.findOne({
//             where: {
//                 cartId
//             },
//             include: [{
//                 model: cart,
//                 include: [{
//                     model: items,
//                     include: [{
//                         model: Product,
//                         include: {
//                             model: image,
//                             where: { imagetype: "product" },
//                             required: false
//                         }
//                     }]
//                 }]
//             }]
//         });

//         // Check if order exists
//         if (!userOrder || !userOrder.cart) {
//             return res.status(404).json({ message: 'Order not found or cart is missing' });
//         }

//         // Get userId from the cart
//         const userId = userOrder.cart.userId;

//         // Handle address
//         let userAddress = await Address.findOne({ where: { userId } });
        
//         if (userAddress) {
//             // Update existing address
//             await userAddress.update({
//                 address: address || userAddress.address,
//                 city: city || userAddress.city,
//                 sector: sector || userAddress.sector
//             });
//         } else {
//             // Create new address
//             userAddress = await Address.create({
//                 sector,
//                 city,
//                 address,
//                 userId
//             });
//         }

//         // Update order with new address and status
//         const updatedOrder = await userOrder.update({
//             addressId: userAddress.id,
//             status: 'send'
//         });

//         res.status(200).json(updatedOrder);

//     } catch (error) {
//         console.error('PlaceOrder Error:', error);
//         res.status(500).json({
//             success: false,
//             message: 'Failed to place order',
//             error: error.message
//         });
//     }
// };

const PlaceOrder = async (req, res) => {
    try {
        const { cartId, sector, city, address } = req.body;

        console.log('cartId from request:', cartId);
        // Check if cart exists
        const cartExists = await cart.findOne({
            where: { id: cartId ,status: 'Active'}
        });

        if (!cartExists) {
            return res.status(404).json({ message: 'Cart not found' });
        }

        // // Find the order with cart details
        const userOrder = await order.findOne({
            where: { cartId ,status: 'InComplete'},
            include: [{
                model: cart,
                include: [{
                    model: items,
                    include: [{
                        model: Product,
                        include: {
                            model: image,
                            where: { imagetype: "product" },
                            required: false
                        }
                    }]
                }]
            }]
        });

        console.log('userOrder:', JSON.stringify(userOrder, null, 2));

        // Get userId from the cart
        const userId = userOrder.Cart.UserId; 

        // Handle address
        let userAddress = await Address.findOne({ where: { userId } });
        
        if (userAddress) {
            // Update existing address
            await userAddress.update({
                address: address || userAddress.address,
                city: city || userAddress.city,
                sector: sector || userAddress.sector
            });
        } else {
            // Create new address
            userAddress = await Address.create({
                sector,
                city,
                address,
                userId
            });
        }


        // Update order with new address and status
        const updatedOrder = await userOrder.update({
            addressId: userAddress.id,
            status: 'send'
        });
         
        //map on items of cart and then from their productid get seller id and then create seller order
        userOrder.Cart.CartItems.map(async (item) => {
            const product = await Product.findByPk(item.productId);
            const sellerId = product.seller;
            await SellerOrder.create({
                sellerId, //2
                customerId: userId,//1 
                orderId: updatedOrder.id,//1
                orderProductId: product.id,//1 or 2 or 4
                status: 'Requested'
            });//seller and order id are same but product id is different
        });

        await cartExists.update({
            status:'Ordered'
        })
        res.status(200).json(updatedOrder);

    } catch (error) {
        console.error('PlaceOrder Error:', error);
        res.status(500).json({
            success: false,
            message: 'Failed to place order',
            error: error.message
        });
    }
};


  export default {ViewCheckout,PlaceOrder}