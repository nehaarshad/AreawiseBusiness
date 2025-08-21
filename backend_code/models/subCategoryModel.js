import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";
import category from "./categoryModel.js";

const subcategories=sequelize.define('subcategories',{
   id:{
         type:DataTypes.INTEGER,
         autoIncrement:true,
         primaryKey:true
   },
   name:{
    type:DataTypes.STRING,
     allowNull:false,
   },
   categoryId:{
    type:DataTypes.INTEGER,
    references:{
        model:category,
        key:'id'
    },
    allowNull:false
   }
   
},
{
    timestamps:true
}
);

export default subcategories;