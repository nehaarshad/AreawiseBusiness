import sequelize from "../config/db_config.js";
import { DataTypes, or } from "sequelize";
import order from "./orderModel.js";

const orderReminder = sequelize.define("orderReminder",{

    id:{
        type:DataTypes.INTEGER,
        primaryKey:true,
        autoIncrement:true,
    },
    sellerOrderId:{
        type:DataTypes.INTEGER,
        allowNull:false,
    },
    orderId:{
        type:DataTypes.INTEGER,
        allowNull:false,
    },
    sellerId:
    {
        type:DataTypes.INTEGER,
        allowNull:false,
    },
    reminderDateTime:{
        type:DataTypes.DATE,
        allowNull:false,
    },
    status:{
        type:DataTypes.BOOLEAN,
        defaultValue:true,
    },


},
    {
        timestamps:true
    },
);

export default orderReminder