import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";
import ServiceProviders from "./serviceProvidersModel.js";

const ServiceDetails = sequelize.define('ServiceDetails', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    serviceDetails: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    cost: {    
        type: DataTypes.INTEGER, 
        allowNull: false 
    },
    providerId: {
        type: DataTypes.INTEGER,
        references: {
            model: ServiceProviders,
            key: 'id'
        }
    },
},
{
    timestamps: true
}
);

export default ServiceDetails;