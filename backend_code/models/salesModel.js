import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const sale = sequelize.define('saleOffers', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    expire_at: {  //Sale ends on
        type: DataTypes.DATE, 
        allowNull: false 
    },
    discount: { //discount Offer
        type: DataTypes.INTEGER, 
        allowNull: false 
    },
    price: { //price after discount
        type: DataTypes.INTEGER, 
        allowNull: false 
    },
    userId: {   //productOwner 
        type: DataTypes.INTEGER, 
        allowNull: false 
    },
    productId: {  //productId on sale
        type: DataTypes.INTEGER, 
        allowNull: false 
    },
    is_active: {  //if sale is active or not
        type: DataTypes.BOOLEAN, 
        defaultValue: true 
    },
},
{
    timestamps: true
}
);

export default sale;