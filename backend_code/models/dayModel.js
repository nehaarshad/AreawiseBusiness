import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";

const Day = sequelize.define("arrivalDays", {
 id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  day: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue:7
  },
  
},
);

export default Day;
