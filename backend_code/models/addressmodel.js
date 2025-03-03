import User from "./userModel.js";
import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const Address = sequelize.define('address', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    sector: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    city: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    address: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    userId: {
        type: DataTypes.INTEGER,
        allowNull: false,
    }
},
{
    timestamps: true
}
);

export default Address;