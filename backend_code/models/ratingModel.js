
import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const rating = sequelize.define('ratings', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    rating: { 
        type: DataTypes.INTEGER, 
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

export default rating;