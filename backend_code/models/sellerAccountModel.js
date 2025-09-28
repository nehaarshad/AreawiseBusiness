import sequelize from "../config/db_config.js";
import { DataTypes } from "sequelize";

const SellerPaymentAccount = sequelize.define('sellerPaymentAccounts', {
    id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
    },
    sellerId: {
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    accountType: {
        type: DataTypes.ENUM('jazzcash', 'easypaisa', 'bankAccount'),
        allowNull: false,
    },
    accountNumber: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    bankName: {
        type: DataTypes.STRING,
        allowNull: true,
    },
    IBAN: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    accountHolderName: {
        type: DataTypes.STRING,
        allowNull: false,
    },
}, {
    timestamps: true
});

export default SellerPaymentAccount;