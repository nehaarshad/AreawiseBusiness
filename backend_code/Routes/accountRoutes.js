import express from 'express';
import accountControllers from '../controllers/sellerAccountControllers.js';
const { getSellerPaymentAccounts, createSellerPaymentAccount, deleteSellerPaymentAccount } = accountControllers;
const accountRouter = express.Router();

accountRouter.post("/createAccount", createSellerPaymentAccount);
accountRouter.get("/getAccounts/:id", getSellerPaymentAccounts);
accountRouter.delete("/deleteAccount/:id", deleteSellerPaymentAccount);


export default accountRouter;