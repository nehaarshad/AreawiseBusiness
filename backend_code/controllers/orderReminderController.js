import orderReminder from "../models/orderReminderModel.js";
import SellerOrder from "../models/sellerOrderModel.js";
import { Op, or } from "sequelize";

const setOrderReminder = async (req, res) => {
    try {
        const { id } = req.params; // userID (Seller ID)
        const userID = parseInt(id);
        const { orderId, reminderDateTime } = req.body;
        console.log("Received data:", { userID, orderId, reminderDateTime });

        const order = await SellerOrder.findOne({
            where: {
                orderId: orderId,
                sellerId: userID
            }
        });
        if(!order){

            return res.json({
                error: 'Order not found',
                message: 'The specified order does not exist for this seller'
            });
        }

        const utcDate = new Date(reminderDateTime);
        const localDate = utcDate.toLocaleString(); // Converts to user's local time

        const setReminder = await orderReminder.create({
            sellerOrderId: order.id,
            orderId: orderId,
            sellerId: userID,
            reminderDateTime: localDate,
        });
        console.log("Reminder set successfully:", setReminder);
        res.status(201).json(setReminder);

    } catch (error) {
        console.log(error);
        res.status(500).json({
            error: 'Internal server error',
            message: 'Failed to set order reminder'
        });
    }
}
const deleteOrderReminder=async(req,res)=>{
    try {
        const {id}=req.params;
        const sellerOrderId= parseInt(id);
        const reminder=await orderReminder.findOne({where:{sellerOrderId}});
        if(!reminder){
            return res.json("Reminder for this order not found");
        }
        await reminder.destroy();
    }
    catch(e){
         console.log(e);
    }
}

export default {setOrderReminder,deleteOrderReminder}
