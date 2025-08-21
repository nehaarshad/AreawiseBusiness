import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";

const Notification = sequelize.define("Notification", {
    
  id:{
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  } , 
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  message: {
    type: DataTypes.STRING,
    allowNull: false
  },
  read: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
}, {
  timestamps: true
});

export default Notification;
