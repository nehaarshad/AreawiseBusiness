import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";

const category=sequelize.define('categories',{
   id:{
         type:DataTypes.INTEGER,
         autoIncrement:true,
         primaryKey:true
   },
   name:{
    type:DataTypes.STRING,
     allowNull:false,
     unique:true
   },
   status:{
    type:DataTypes.STRING,
    defaultValue:"Requested"
   }
   
},{
  timestamps:true
}
);

export default category;