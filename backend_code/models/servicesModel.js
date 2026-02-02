import User from "./userModel.js";
import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";
import category from "./categoryModel.js";

const services = sequelize.define('services', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    name: { 
        type: DataTypes.STRING, 
    },
    imageUrl:{
        type: DataTypes.STRING,
        allowNull:false,
    },
    status:{
        type:DataTypes.STRING,
        allowNull:false,
    },
},
{
    timestamps: true
}
);

export default services;