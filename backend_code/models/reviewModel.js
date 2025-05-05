import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const review = sequelize.define('reviews', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    comment: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    userId: { 
        type: DataTypes.INTEGER, 
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

export default review;