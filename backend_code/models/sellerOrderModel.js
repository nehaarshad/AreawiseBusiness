import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";

const SellerOrder = sequelize.define("SellerOrder", {
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
    },
    sellerId: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    customerId: { //which customer ordered the product  and also used to get delivery addresss
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    orderId: { 
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    orderProductId: {  //which product to be ordered
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    status: {
        type: DataTypes.STRING, //Requested, Approved, Rejected, Dispatched, Delivered, completed
        allowNull: false,
    },
},
{
    timestamps:true,
});

export default SellerOrder;

//seller get orders as: which Product is ordered by which user (Info on detailed screen)and what is the status of that order
//seller can update the status of the order
//DetailView: orderes Product Name, Image, Price, Quantity, Customer Info with address, OrderStatus