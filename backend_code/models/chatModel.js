import { DataTypes } from 'sequelize';
import sequelize from '../config/db_config.js';

const Chat = sequelize.define('Chat', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  buyerId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  sellerId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  productId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  lastMessageAt: {
    type: DataTypes.DATE,
    allowNull: true
  }
},
{
  timestamps: true,
});

export default Chat;
