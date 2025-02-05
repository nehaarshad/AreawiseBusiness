import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";

const image = sequelize.define('Image', { 
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true, 
    }, 
    imagetype: { 
        type: DataTypes.ENUM('product', 'user', 'shop'),
        allowNull: false, 
    }, 
    UserId: { 
        type: DataTypes.INTEGER, 
        allowNull: true, 
    }, 
    ProductId: { 
        type: DataTypes.INTEGER, 
        allowNull: true, 
    }, 
    ShopId: { 
        type: DataTypes.INTEGER, 
        allowNull: true, 
    }, 
    imageData: { 
        type: DataTypes.BLOB,  //actual image data,name,exe etc
         allowNull: true, 
    }, 
    imageUrl: {
         type: DataTypes.STRING, //path of uploaded image
         allowNull: true, 
    },
 },
 {
    timestamps:true
}
);

export default image;