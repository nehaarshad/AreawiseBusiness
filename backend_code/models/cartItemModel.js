import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";

const items=sequelize.define('CartItems',{
   id:{
         type:DataTypes.INTEGER,
         autoIncrement:true,
         primaryKey:true
   },
   cartId:{   // add to cart which belogs to a specific user
    type:DataTypes.INTEGER,
     allowNull:false,
   },
  sellerId:{  //seller id of the product that is added to cart
    type:DataTypes.INTEGER,
     allowNull:false,
   },
   productId:{    //which product to be added
    type:DataTypes.INTEGER,
     allowNull:false,
   },
   quantity:{  //quatity of product ordered
    type:DataTypes.INTEGER,
     allowNull:false,
     defaultValue: 1,
   },
   price:{  //product.price * quatity
    type:DataTypes.INTEGER,
     allowNull:false,
   },
   shippingPrice:{  
    type:DataTypes.INTEGER,
     allowNull:false,
     defaultValue: 0,
   },
   status:{
    type:DataTypes.STRING, //order item is approved or rejectedd etc...
    allowNull:true
   }
   
},{
  timestamps:true
}
);

export default items;