import User from "./userModel.js";
import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";
import category from "./categoryModel.js";

const shop = sequelize.define('shops', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    shopname: { 
        type: DataTypes.STRING, 
    },
    shopaddress: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    sector: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    city: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    status:{
        type:DataTypes.STRING,
        allowNull:false,
        defaultValue:"Processing..."
    },
    deliveryPrice:{
        type:DataTypes.INTEGER,
        allowNull:false,
        defaultValue:0
    },
    categoryId: {
        type: DataTypes.INTEGER,
        references: {
            model: category,
            key: 'id'
        },
        allowNull: false
    },
    userId: {
        type: DataTypes.INTEGER,
        references: {
            model: User,
            key: 'id'
        }
    }
},
{
    timestamps: true
}
);

export default shop;