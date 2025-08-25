import SellerPaymentAccount from "../models/sellerAccountModel.js";
import User from "../models/userModel.js";

const getSellerPaymentAccounts = async (req, res) => {
    try {
        const {id} = req.params;
        const paymentAccounts = await SellerPaymentAccount.findAll({
            where: { sellerId:id },
            include:{
                model:User
            }
        });
        console.log("Fetched seller payment accounts:", paymentAccounts);
        res.status(200).json(paymentAccounts);
    } catch (error) {
        console.error("Error fetching seller payment accounts:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

const createSellerPaymentAccount = async (req, res) => {
    try {
        const { sellerId, accountType, accountNumber, bankName, IBAN, accountHolderName } = req.body;
        console.log(req.body);
        const newAccount = await SellerPaymentAccount.create({
            sellerId,
            accountType,
            accountNumber,
            bankName,
            IBAN,
            accountHolderName
        });
        console.log("New seller payment account created:", newAccount);
        res.status(201).json(newAccount);
    } catch (error) {
        console.error("Error creating seller payment account:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

const deleteSellerPaymentAccount = async (req, res) => {
    try {
        const { id } = req.params;
        await SellerPaymentAccount.destroy({
            where: { id }
        });
        res.json("Deleted Successfully");
    } catch (error) {
        console.error("Error deleting seller payment account:", error);
        res.status(500).json({ error: "Internal server error" });
    }
};

export default {
    getSellerPaymentAccounts,
    createSellerPaymentAccount,
    deleteSellerPaymentAccount
};