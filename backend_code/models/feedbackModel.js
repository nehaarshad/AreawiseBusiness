import User from "./userModel.js";
import { DataTypes } from "sequelize";
import sequelize from "../config/db_config.js";

const feedback = sequelize.define('feedback', {
    id: { 
        type: DataTypes.INTEGER, 
        autoIncrement: true, 
        primaryKey: true 
    },
    comment: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
    email: { 
        type: DataTypes.STRING, 
        allowNull: false 
    },
},
{
    timestamps: true
}
);

export default feedback;