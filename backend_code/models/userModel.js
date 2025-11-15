import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const User = sequelize.define('users', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    username: { 
        type: DataTypes.STRING, 
        allowNull: false,
        unique: true 
    },
    email: { 
        type: DataTypes.STRING, 
        allowNull: false, 
        unique: true,
        validate: {
            isEmail: true  
        }
    },
    contactnumber: { 
        type: DataTypes.BIGINT, 
        allowNull: false 
    },
    password: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    role: { 
        type: DataTypes.STRING, 
        allowNull: false, 
        defaultValue: 'Buyer' 
    }
},
{
    timestamps: true
}
);

export default User;
