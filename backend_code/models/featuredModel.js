import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const featured=sequelize.define("featuredProducts",{
    id:{
        type:DataTypes.INTEGER,
        primaryKey:true,
        autoIncrement:true,
    },
    productID:{
        type:DataTypes.INTEGER,
        allowNull:false
    },
    userID:{
        type:DataTypes.INTEGER,
        allowNull:false
    },
    status:{
        type:DataTypes.STRING,  //requested / if approved (featured) / rejected / dismissed 
        allowNull:false,
        defaultValue:"Requested"
    },
    expire_at:{
        type:DataTypes.DATE,
        allowNull:false
    }
},
{
    timestamps:true
});

export default featured