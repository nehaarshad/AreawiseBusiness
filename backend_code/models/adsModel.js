import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const Ads=sequelize.define('ADs',{

    id:{
        type:DataTypes.INTEGER,
        primaryKey:true,
        autoIncrement:true
    },
    sellerId:{
        type:DataTypes.INTEGER,
        allowNull: false
    },
    expire_at:{
        type:DataTypes.DATE,
        allowNull: false
    },
    is_active:{
        type:DataTypes.BOOLEAN,
        defaultValue:true
    }
},
{
    timestamps: true
});

export default Ads;