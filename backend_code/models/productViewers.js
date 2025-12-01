import User from "./userModel.js";
import shop from "./shopmodel.js";
import subcategories from "./subCategoryModel.js"
import category from "./categoryModel.js"
import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const Viewers = sequelize.define('viewers', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    userId: { 
        type: DataTypes.INTEGER, 
        allowNull: false 
    },
    ProductId: { 
        type: DataTypes.INTEGER, 
        defaultValue:0,
    },
},
{
    timestamps: true
}
);

export default Viewers;