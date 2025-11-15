import Ads from '../models/adsModel.js';
import cron from 'node-cron';
import featured from '../models/featuredModel.js';
import sale from '../models/salesModel.js';
import Product from '../models/productModel.js';
import sendNotificationToUser from '../utils/sendNotification.js';
import { Op } from 'sequelize';
import orderReminder from '../models/orderReminderModel.js';

const scheduler=(io,userSocket)=>{
    console.log("Cron job initialized. Waiting for the next scheduled run...");
cron.schedule('* * * * *', async () => { // runs after each hour every minute 1-31 dayOfMonth 1-12 Month 1-7DayOfWeek
    try {
        
      console.log("scheduler is in running state");
      const currentDate = new Date();

      //for advertisements
      const expiredAds = await Ads.findAll({
        where: {
          expire_at: { [Op.lt]: currentDate },  //check set date is less than current date
          is_active: true
        }
      });

       //for onSale Products
      const onSale = await sale.findAll({
        where: {
          expire_at: { [Op.lt]: currentDate },
          is_active: true
        }
      });

      const reminderOrders = await orderReminder.findAll({
          where: {
            reminderDateTime: { [Op.lte]: currentDate },
            status: true
          }
      });

      //for featureProducts
      const expiredFeaturedProduct = await featured.findAll({
        where: {
          expire_at: { [Op.lt]: currentDate },  //check set date is less than current date
          status: "featured"
        }
      });

      for (const ad of expiredAds) {
        await ad.destroy();
        console.log(`Ad ${ad.id} deleted due to expiration`);
      }

      for (const orderReminder of reminderOrders) {
        const NotificationMessage = `Reminder: You have an order (ID: ${orderReminder.orderId}) that requires your attention.`;
                 if (io && userSocket) {
                     await sendNotificationToUser(io, userSocket, orderReminder.sellerId, NotificationMessage);
                 } 
        await orderReminder.destroy();
        console.log(`Order reminder ${orderReminder.id} processed and notification sent.`);
      }

      for (const sale of onSale) {
        await Product.update({ onSale: false }, { where: { id: sale.productId } }); //update the product onSale status to false
        await sale.destroy();
        console.log(`onSale ${sale.id} deleted due to expiration`);
      }

      for (const feature of expiredFeaturedProduct) {
       await feature.destroy(); //delete the expired featured product from the database
        console.log(`feature ${feature.id} deleted due to expiration`);
      }

      console.log("scheduler is in off state");
    } catch (error) {
      console.error('Error in cron job for deactivating expired ads:', error);
    }
  });
}

export default scheduler