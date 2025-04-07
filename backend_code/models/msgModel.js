import { DataTypes } from 'sequelize';
import sequelize from '../config/db_config.js';

const Message = sequelize.define('Message', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  chatId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  senderId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  msg: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  status: {
    type: DataTypes.BOOLEAN, //sent or not + read or not
    allowNull: false,
    defaultValue: false
  },
},{
  timestamps: true,
  }
);

export default Message;