import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";

const wishList = sequelize.define('WishList', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    userId: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    productId: {
        type: DataTypes.INTEGER,
        allowNull: false
    }
}, 
{
    timestamps: true
});

export default wishList;