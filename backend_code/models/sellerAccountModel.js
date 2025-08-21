import sequelize from "../config/db_config";
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
        type: DataTypes.INTEGER,
        allowNull: false,
    },
    bankName: {
        type: DataTypes.STRING,
        allowNull: true,
    },
    IBAN: {
        type: DataTypes.STRING,
        allowNull: false,
    },
    accountHolderName: {
        type: DataTypes.STRING,
        allowNull: false,
    },
}, {
    timestamps: true
});

export default SellerPaymentAccount;