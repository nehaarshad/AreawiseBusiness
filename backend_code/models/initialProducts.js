import User from "./userModel.js";
import shop from "./shopmodel.js";
import subcategories from "./subCategoryModel.js"
import category from "./categoryModel.js"
import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const InitialProduct = sequelize.define('InitialProduct', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    name: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    subtitle: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    price: { 
        type: DataTypes.INTEGER, 
        allowNull: false 
    },
    condition: { 
        type: DataTypes.STRING, //New or Used
        allowNull: false 
    },
    onSale: { 
        type: DataTypes.BOOLEAN, 
        allowNull: false, 
        defaultValue:false
    },
    description: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    stock: { 
        type: DataTypes.INTEGER, 
        allowNull: false 
    },
    sold: { 
        type: DataTypes.INTEGER, 
        defaultValue:0,
    },
    ratings: { 
        type: DataTypes.INTEGER, 
        defaultValue:0,
    },
    seller: {
        type: DataTypes.INTEGER,
        references: {
            model: User,
            key: 'id'
        }
    },
    shopid: {
        type: DataTypes.INTEGER,
        references: {
            model: shop,
            key: 'id'
        }
    },
    categoryId: {
        type: DataTypes.INTEGER,
        references: {
            model: category,
            key: 'id'
        },
        allowNull: true
    },
    subcategoryId: {
        
        type: DataTypes.INTEGER,
        references: {
            model: subcategories,
            key: 'id'
        },
        allowNull: true
    },
    views:{
        type:DataTypes.INTEGER,
        defaultValue:0
    },
    onCartCounts:{
        type:DataTypes.INTEGER,
        defaultValue:0
    }
},
{
    timestamps: true
}
);

export default InitialProduct;