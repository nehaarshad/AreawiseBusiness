import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const color = sequelize.define('colors', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    color: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    productId: { 
        type: DataTypes.INTEGER, 
        allowNull: false 
    },
   
},
{
    timestamps: true
}
);

export default color;