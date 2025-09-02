import SellerOrder from "../models/sellerOrderModel.js";
import cart from "../models/CartModel.js";
import items from "../models/cartItemModel.js";
import Product from "../models/productModel.js";
import image from "../models/imagesModel.js";
import Address from "../models/addressmodel.js";
import User from "../models/userModel.js";
import order from "../models/orderModel.js";
import sendNotificationToUser from "../utils/sendNotification.js";
import { or } from "sequelize";

const getSellerOrders = async (req, res) => { 
    try {
        const { id } = req.params; // id of the seller
        const orders = await SellerOrder.findAll({
            where: {
                sellerId: id,
            },
             order: [['createdAt', 'DESC']], 
            include: [{
                model:order,
                include:[
                    {
                    model: cart,
                    include: [
                        {
                            model:User,
                            include:{
                                model:Address,
                            }
                        },
                        {
                        model: items,
                        include: [{
                            model: Product,
                            include: {
                                model: image,
                                where: { imagetype: "product" },
                                required: false
                            }
                        }]
                    }
                ]
            }
        ]
            }
        ]
        });
        //include only those items where the productId matches the orderProductId from the SellerOrderTable
        const filteredOrders = orders.map(order => {
            const filteredCartItems = order.Order.Cart.CartItems.filter(item => 
                item.productId === order.orderProductId);

            return {//returning the filtered orders  //spreading the original order details and replacing the CartItems with the filtered list.
                ...order.toJSON(),
                Order: {
                    ...order.Order.toJSON(),
                    Cart: {
                        ...order.Order.Cart.toJSON(),
                        CartItems: filteredCartItems
                    }
                }
            };
        });

        console.log('Filtered Orders:', JSON.stringify(filteredOrders, null, 2));
        res.json(filteredOrders);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "Server Error" });
    }
};

const getCustomerOrders = async (req, res) => { 
    try {
        const { id } = req.params; // id of the customer
          // Fetch all orders for the user
        const orders = await order.findAll({
             where: { status: 'send'},
            order: [['createdAt', 'DESC']], // Order by creation date, most recent first
                    include: [
                        {
                            model: cart,
                             where: { UserId: id },
                            include: [
                                {
                                    model: items,
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

        if (!orders || orders.length === 0) {
            return res.status(200).json({ message: 'No orders found for this user' });
        }
console.log(orders);
        res.status(200).json(orders);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "Server Error" });
    }
};

const updateOrderStatus = async (req, res) => {
    try {
        const { id } = req.params;  // order id
        const { productId, status } = req.body;
        
        const sellerOrder = await SellerOrder.findOne({
            where: {
                orderId: id,
                orderProductId: productId,
            }
        });
        
        if (!sellerOrder) {
            return res.status(404).json({ message: "Order not found" });
        }

         const orderDetails = await order.findOne({ 
                where: { id: id },
                include: [
                    
                    {
                        model: cart,
                        include: [
                            {
                        model: User, 
                    },
                    {
                        model: items,
                        where: { productId: productId }
                    }]
                }
            ]
            });
        
        // If status is being updated to "Approved", update product stock and sold count
        if (status === "Approved" && sellerOrder.status !== "Approved") {
            
            // ordered quantity
            const orderedQuantity = orderDetails.Cart.CartItems[0].quantity;
           
            // Get product to update its stock and sold count
            const product = await Product.findByPk(productId);
            product.stock = product.stock - orderedQuantity;
            product.sold = product.sold + orderedQuantity;
            
            if(product.stock < 0){
                product.stock =0
            }
            // Save the product changes
            await product.save();
        }
        
        // If status is being updated to "Rejected", update order total price
         if (status === "Rejected" && sellerOrder.status !== "Rejected") {
          // ordered quantity
            const orderedPrice = orderDetails.Cart.CartItems[0].price;
            orderDetails.total=orderDetails.total-orderedPrice;
            await orderDetails.save();

         }
        // Update the order and item status
        await orderDetails.Cart.CartItems[0].update({ status: status });
        sellerOrder.status = status;
        await sellerOrder.save();

          const buyerId = orderDetails.Cart.UserId; 
             const notificationMessage = `Your ordered product Item #"${orderDetails.Cart.CartItems[0].id}" status has been updated to "${status}" `;
    
             if (req.io && req.userSockets) {
             await sendNotificationToUser(req.io, req.userSockets, buyerId, notificationMessage);
             }
        
        res.json(sellerOrder);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "Server Error" });
    }
};

export default { getSellerOrders,getCustomerOrders, updateOrderStatus };