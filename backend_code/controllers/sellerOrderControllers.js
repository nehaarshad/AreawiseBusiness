import SellerOrder from "../models/sellerOrderModel.js";
import cart from "../models/CartModel.js";
import items from "../models/cartItemModel.js";
import Product from "../models/productModel.js";
import image from "../models/imagesModel.js";
import Address from "../models/addressmodel.js";
import User from "../models/userModel.js";
import order from "../models/orderModel.js";

const getSellerOrders = async (req, res) => { 
    try {
        const { id } = req.params; // id of the seller
        const orders = await SellerOrder.findAll({
            where: {
                sellerId: id,
            },
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

        res.json(filteredOrders);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "Server Error" });
    }
};

const getCustomerOrders = async (req, res) => { 
    try {
        const { id } = req.params; // id of the customer
        const orders = await SellerOrder.findAll({
            where: {
                customerId: id,
            },
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

        res.json(filteredOrders);
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
        
        // If status is being updated to "Approved", update product stock and sold count
        if (status === "Approved" && sellerOrder.status !== "Approved") {
            // First, get the order details to access the cart
            const orderDetails = await order.findOne({ 
                where: { id: id },
                include: [{
                    model: cart,
                    include: [{
                        model: items,
                        where: { productId: productId }
                    }]
                }]
            });
            
            // ordered quantity
            const orderedQuantity = orderDetails.Cart.CartItems[0].quantity;
            
            // Get product to update its stock and sold count
            const product = await Product.findByPk(productId);
            product.stock = product.stock - orderedQuantity;
            product.sold = product.sold + orderedQuantity;
            
            // Save the product changes
            await product.save();
        }
        
        // Update the order status
        sellerOrder.status = status;
        await sellerOrder.save();
        
        res.json(sellerOrder);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "Server Error" });
    }
};

export default { getSellerOrders,getCustomerOrders, updateOrderStatus };