import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";
import image from "./imagesModel.js";

const User = sequelize.define('users', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    username: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    email: { 
        type: DataTypes.STRING, 
        allowNull: false, 
        unique: true 
    },
    contactnumber: { 
        type: DataTypes.INTEGER, 
        allowNull: false 
    },
    password: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    role: { 
        type: DataTypes.ENUM('admin', 'seller', 'buyer'), 
        allowNull: false, 
        defaultValue: 'buyer' 
    }
},
{
    timestamps: true
}
);

export default User;
