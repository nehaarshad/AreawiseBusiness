import { DataTypes } from 'sequelize';
import sequelize from '../config/db_config.js';

const TokenBlacklist = sequelize.define('TokenBlacklist', {
    token: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
    },
});

export default TokenBlacklist;