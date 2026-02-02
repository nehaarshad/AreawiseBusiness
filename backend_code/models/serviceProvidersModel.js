import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";
import services from "./servicesModel.js";
import User from "./userModel.js";

const ServiceProviders = sequelize.define('ServiceProviders', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    providerName: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    providerID:{
        type: DataTypes.INTEGER,  //userId
        allowNull:false,
        references: {
            model: User,
            key: 'id'
        }
    },
    email: { 
        type: DataTypes.STRING, 
        allowNull: false, 
        validate: {
            isEmail: true  
        }
    },
    ImageUrl:{
        type: DataTypes.STRING,
        allowNull:false,
    },
    contactnumber: { 
        type: DataTypes.BIGINT, 
        allowNull: false 
    },
    experience: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    OpenHours: {    //about service provider availability
        type: DataTypes.STRING, 
        allowNull: false 
    },
    location: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    serviceId: {
        type: DataTypes.INTEGER,
        references: {
            model: services,
            key: 'id'
        }
    },
},
{
    timestamps: true
}
);

export default ServiceProviders;