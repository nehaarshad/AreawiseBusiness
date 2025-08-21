import cart from '../models/CartModel.js'
import items from '../models/cartItemModel.js'
import Product from '../models/productModel.js'
import order from '../models/orderModel.js'
import Address from '../models/addressmodel.js'
import image from "../models/imagesModel.js";
import SellerOrder from '../models/sellerOrderModel.js'
import delivery from '../models/deliveryOrderAttributes.js'
import sendNotificationToUser from '../utils/sendNotification.js';


//onCheckoutButtonClick
const ViewCheckout = async (req, res) => {
  try {
      const { id } = req.params;  // id of cart to be checked out
       let { total} = req.body; // userId from the request body 
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


        const attributes=await delivery.findByPk(1);
    let discountOffer = 0; // 0% discount
    if(total>=attributes.totalBill){
        discountOffer = attributes.discount; // 10% discount
          total = total - (total * discountOffer) + attributes.shippingPrice;
          discountOffer = discountOffer * 100;
    }
          else{
          total = total + attributes.shippingPrice;
          }

      console.log('User Cart:', JSON.stringify(userCart, null, 2));

      // Create the order
      const newOrder = await order.create({
          cartId: userCart.id,
          addressId: 1,  // by default address id is 1 randomly but can be set when user places order
          total: total,
          discount: attributes.discount,
          shippingPrice: attributes.shippingPrice,
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
    console.error('ViewCheckout Error:', error);
      res.status(500).json({ message: error.message });
  }
};

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
            });

                 const notificationMessage = `The new request for product #${product.id} in Order #${updatedOrder.id}.`;
                   if (req.io && req.userSockets) {
                     await sendNotificationToUser(req.io, req.userSockets, sellerId, notificationMessage);
                     }
           await item.update({ status: 'Requested' });
        });

        await cartExists.update({
            status:'Ordered'
        })

              const buyerId = userId; 
                 const buyerNotificationMessage = `Your Order #"${updatedOrder.id}" has been placed successfully.`;
                  if (req.io && req.userSockets) {
                     await sendNotificationToUser(req.io, req.userSockets, buyerId, buyerNotificationMessage);
                     }

        res.status(200).json(updatedOrder);

    } catch (error) {
        console.error('PlaceOrder Error:', error);
        res.json({
            success: false,
            message: 'Failed to place order',
            error: error.message
        });
    }
};

const updateDeliveryOrderAttributes=async (req, res) => {
    try {

        const {totalBill,discount,shippingPrice}=req.body;
        console.log("in update orders",req.body);

         let offers=await delivery.findByPk(1);
        
                if(!offers){
                    offers=await delivery.create({shippingPrice,totalBill,discount}) 
                }
        
                offers.totalBill = totalBill;
                offers.shippingPrice = shippingPrice;
                offers.discount = discount;
                await offers.save()

                console.log("updated offer",offers)

        res.status(200).json(
           offers
        );

        
    } catch (error) {
           console.log(error);
        res.json({ error: "  FAILED TO UPDATE!" })
        
    }
}

const getDeliveryOrderAttributes=async (req, res) => {
    try {
         const get = await delivery.findByPk(1);
        

        res.status(200).json(
           get
        );

        
    } catch (error) {
           console.log(error);
        res.json({ error: "  FAILED TO Fetch!" })
        
    }
}


  export default {ViewCheckout,PlaceOrder,updateDeliveryOrderAttributes,getDeliveryOrderAttributes};