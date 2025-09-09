import express from "express";
import  transcriptController  from "../controllers/transactionController.js";
import {upload} from "../MiddleWares/uploadimage.js";
const transcriptRouter = express.Router();
const {uploadOrderOnlineTransactionSlip,getOrderOnlineTransactionSlip}=transcriptController;

transcriptRouter.post("/uploadTransactionSlip", upload.single('image'), uploadOrderOnlineTransactionSlip);
transcriptRouter.post("/getTransactionSlip", getOrderOnlineTransactionSlip);


export default transcriptRouter;
