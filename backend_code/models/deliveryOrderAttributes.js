import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const delivery=sequelize.define('DeliveryOrderAttributes',{

    id:{
        type:DataTypes.INTEGER,
        primaryKey:true,
        autoIncrement:true
    },
    shippingPrice:{
        type:DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 200
    },
    discount:{
        type:DataTypes.DECIMAL(2,2), //
        allowNull: false,
        defaultValue: 0.1
    },
    totalBill:{
        type:DataTypes.DECIMAL(10,2),
        allowNull: false,
        defaultValue: 5000
    }
},
{
    timestamps: true
});

export default delivery;