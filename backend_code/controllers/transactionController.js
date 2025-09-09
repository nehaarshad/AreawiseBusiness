import image from "../models/imagesModel.js";
import path from "path";
import dotenv from "dotenv";
import { fileURLToPath } from "url";
import { optimizeImage } from "../MiddleWares/uploadimage.js";
const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);
dotenv.config();

const uploadOrderOnlineTransactionSlip=async(req,res)=>{

    try {

        const {orderId,sellerId}=req.body;
        if (!req.file) {
            return res.json({ error: 'No file uploaded' });
        }
        console.log('Uploading transaction slip:', req.body, req.file);
        
       if (req.file) {
         const originalPath = req.file.path;
                            const optimizedFilename = 'optimized-' + req.file.filename;
                            const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
                            
                            // Optimize the image
                            await optimizeImage(originalPath, optimizedPath);
            const imageUrl = `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`;
            await image.create({ imagetype: 'transcript', orderId,sellerId, imageUrl });
        }
        res.status(200).json({message:"true"});
    } catch (error) {
        console.log('Error uploading transaction slip:', error);
        res.status(500).json({ error: 'Failed to upload transaction slip' });
    }

}

const getOrderOnlineTransactionSlip=async(req,res)=>{

    try {

        const {orderId,sellerId}=req.body;
        console.log('Fetching transaction slip for Order ID:', orderId, 'Seller ID:', sellerId);
        const transactionSlip = await image.findAll(
            { where: { imagetype: 'transcript', orderId, sellerId },attributes: ['imageUrl'] },
            { order: [['createdAt', 'DESC']] }
        );
        if (!transactionSlip) {
               console.log('Transaction Slip not Found:', transactionSlip);
            return res.status(404).json({ error: 'Transaction slip not found' });
        }
        console.log('Transaction Slip Found:', transactionSlip);
        res.status(200).json(transactionSlip);
    } catch (error) {
        console.log('Error getting transaction slip:', error);
        res.status(500).json({ error: 'Failed to get transaction slip' });
    }

}

export default {
    uploadOrderOnlineTransactionSlip,
    getOrderOnlineTransactionSlip
};