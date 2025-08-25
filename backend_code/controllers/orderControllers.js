import cart from '../models/CartModel.js'
import items from '../models/cartItemModel.js'
import Product from '../models/productModel.js'
import order from '../models/orderModel.js'
import Address from '../models/addressmodel.js'
import image from "../models/imagesModel.js";
import SellerOrder from '../models/sellerOrderModel.js'
import delivery from '../models/deliveryOrderAttributes.js'
import sendNotificationToUser from '../utils/sendNotification.js';
import SellerPaymentAccount from "../models/sellerAccountModel.js";
import shop from '../models/shopmodel.js'


//onCheckoutButtonClick
const ViewCheckout = async (req, res) => {
  try {
      const { id } = req.params;  // id of cart to be checked out
      let { shippingPrice } = req.body;    //sum of deliveryChargesOfCartItems

      const userCart = await cart.findByPk(id, {
          include: [
              {
                  model: items,
                  as: 'CartItems',
                  include: [
                      {
                          model: Product,
                          include: [{
                              model: image,
                              where: { imagetype: "product" },
                              required: false
                          },
                          {
                            model:shop
                          }
                        ]
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


    const subtotal = userCart.CartItems.reduce((acc, item) => acc + item.price, 0);
    const attributes = await delivery.findByPk(1);
    let discountOffer = 0; // 0% discount
    if(subtotal>=attributes.totalBill){
        discountOffer = attributes.discount; // 10% discount
          userCart.total = subtotal - (subtotal * discountOffer) ;
          discountOffer = discountOffer * 100;
    }
          else{
          userCart.total = subtotal ;
          }

      console.log('User Cart:', JSON.stringify(userCart, null, 2));

      // Create the order
      const [newOrder] = await order.findOrCreate({
          where: {
              cartId: userCart.id,
              addressId: 0,  // by default address id is 0 randomly but can be set when user places order
              total: userCart.total,
              discount: discountOffer,
              status: 'InComplete' // Initial status of the order
          }
      });


      console.log('New Order Created:', [newOrder]);
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
                                  include: [{
                                      model: image,
                                      where: { imagetype: "product" },
                                      required: false
                                  },
                                {
                                    model:shop
                                }]
                              }
                          ]
                      }
                  ]
              }
          ]
      });


      // Group seller items to create its payments 
        const sellerGroups = {}; //{1:[p1,p2],2:[p3]}

        for (const item of ordered.Cart.CartItems) {
            const sellerId = item.sellerId;
            if (!sellerGroups[sellerId]) { //key->sellerID
                sellerGroups[sellerId] = []; //value->seller items array in the order
            }
            sellerGroups[sellerId].push(item); // push item object to access its shop or data 
        }

        const payments = [];

        // Create payment record for each seller
        for (const [sellerId, items] of Object.entries(sellerGroups)) {
            const sellerAmount = items.reduce((total, item) => {
                return total + item.price;
            }, 0);

            // Get seller's payment account info
            const sellerAccount = await SellerPaymentAccount.findAll({
                where: { sellerId }
            });

            console.log('Seller Account Info:', sellerAccount);
                  if (!sellerGroups[sellerId]) { //key->sellerID
                sellerGroups[sellerId] = []; //value->seller items array in the order
            }
            payments.push({
               sellerId: sellerId,
               amount: sellerAmount,
               accounts: sellerAccount,
               orderId: newOrder.id,
               items: items.map(item => item) // For reference
    });
        }

        console.log('Payments Info:', payments);

      // Return the sellerAccounts for online payment
      res.json( payments );
  } catch (error) {
    console.error('ViewCheckout Error:', error);
      res.status(500).json({ message: error.message });
  }
};

const PlaceOrder = async (req, res) => {
    try {
        const { cartId, sector, city, address,paymentMethod,paymentStatus } = req.body;

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
            status: 'send',
            paymentMethod: paymentMethod,
            paymentStatus: paymentStatus
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