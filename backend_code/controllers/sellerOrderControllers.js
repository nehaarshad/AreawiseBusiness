import SellerOrder from "../models/sellerOrderModel.js";
import cart from "../models/CartModel.js";
import items from "../models/cartItemModel.js";
import Product from "../models/productmodel.js";
import image from "../models/imagesModel.js";
import Address from "../models/addressmodel.js";
import User from "../models/userModel.js";

const getSellerOrders = async (req, res) => { 
    try {
        const { id } = req.params; // id of the seller
        const orders = await SellerOrder.findAll({
            where: {
                sellerId: id,
            },
            include: [{
                model: User,
                include:{
                        model:Address
                       },
                    },
                    {
                        model: Product,
                        include: {
                                model: image,
                            },
                    },
        ],
        });
        res.json(orders);
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
        res.json(orders);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "Server Error" });
    }
};

const updateOrderStatus = async (req, res) => {
    try {
        const { id } = req.params;  //id of product on requested
        const {status } = req.body;
        const order = await SellerOrder.findOne({
            where:{
                orderProductId:id,
            }
        });
        if (!order) {
            return res.status(404).json({ message: "Order not found" });
        }
        order.status = status;
        await order.save();
        res.json(order);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: "Server Error" });
    }
};

export default { getSellerOrders,getCustomerOrders, updateOrderStatus };