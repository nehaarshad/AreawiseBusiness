import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";

const cart=sequelize.define('Cart',{
   id:{
         type:DataTypes.INTEGER,
         autoIncrement:true,
         primaryKey:true
   },
   UserId:{
    type:DataTypes.INTEGER,  //to create cart of specif user ->when user click on add to cart ->user id passed as params and product id send as req.body
     allowNull:false,
   },
   total:{
    type:DataTypes.INTEGER, 
    allowNull:false,
   },
   status:{
    type:DataTypes.STRING,  
       allowNull:false,
     defaultValue:"Active"  //not ordered yet... if click on order button cart status is set as Ordered and new cart is created for second time
   }
   
},{
  timestamps:true
}
);

export default cart;