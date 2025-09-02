import image from "../models/imagesModel.js";

const uploadOrderOnlineTransactionSlip=async(req,res)=>{

    try {

        const {orderId,sellerId}=req.body;
        if (!req.file) {
            return res.json({ error: 'No file uploaded' });
        }
        console.log('Uploading transaction slip:', req.body, req.file);
        
       if (req.file) {
            const imageUrl = `${process.env.baseUrl}/backend_code/uploads/${req.file.filename}`;
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
            { where: { imagetype: 'transcript', orderId, sellerId } },
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