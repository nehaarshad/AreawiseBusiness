import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";

const order = sequelize.define('Orders', { 
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true, 
    },
    cartId: {   //in which user details can be retrived using foreign key of user used in cart model
        type: DataTypes.INTEGER, 
        allowNull: false, 
    }, 
    addressId: {   //address of user where order is to be delivered  ,can be differ from address set in profile
        type: DataTypes.INTEGER, 
        allowNull: false, 
    },
    total: { 
        type: DataTypes.INTEGER, 
        allowNull: false, 
    }, 
    discount: { 
        type: DataTypes.DOUBLE, 
        allowNull: true, 
    },
    shippingPrice: { 
        type: DataTypes.DOUBLE, 
        allowNull: false, 
    },
    status: {
         type: DataTypes.STRING, //on pending,send,approved,completed
         allowNull: false,
    },
    paymentMethod: {
        type: DataTypes.ENUM('cash', 'jazzcash', 'easypaisa', 'bankAccount'),
        allowNull: true, // Can be null initially
    },
    paymentStatus: {
        type: DataTypes.ENUM('cashOnDelivery', 'paid'),
        allowNull: false,
        defaultValue: 'cashOnDelivery'
    }
 },
 {
    timestamps:true
}
);

export default order;