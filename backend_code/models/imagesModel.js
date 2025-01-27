import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";

const image = sequelize.define('Image', { 
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true, 
    }, 
    imagetype: { 
        type: DataTypes.ENUM('product', 'user', 'shop'), //with which entity image is associated
        allowNull: false, 
    }, 
    entityId: { 
        type: DataTypes.INTEGER, //id of entity with which image is associated (product->PID,)
        allowNull: false, 
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