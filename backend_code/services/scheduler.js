import Ads from '../models/adsModel.js';
import cron from 'node-cron';
import featured from '../models/featuredModel.js';
import { Op } from 'sequelize';

const scheduler=()=>{
    console.log("Cron job initialized. Waiting for the next scheduled run...");
cron.schedule('* * * * *', async () => { // runs after each hour 1-31 dayOfMonth 1-12 Month 1-7DayOfWeek
    try {
        
      console.log("scheduler is in running state");
      const currentDate = new Date();
      const expiredAds = await Ads.findAll({
        where: {
          expire_at: { [Op.lt]: currentDate },  //check set date is less than current date
          is_active: true
        }
      });
      const expiredFeaturedProduct = await featured.findAll({
        where: {
          expire_at: { [Op.lt]: currentDate },  //check set date is less than current date
          status: "featured"
        }
      });

      for (const ad of expiredAds) {
        ad.is_active = false;
        await ad.save();
        console.log(`Ad ${ad.id} deactivated due to expiration`);
      }

      for (const feature of expiredFeaturedProduct) {
        feature.status="Dismissed"
        await feature.save();
        console.log(`feature ${feature.id} deactivated due to expiration`);
      }
      
      console.log("scheduler is in off state");
    } catch (error) {
      console.error('Error in cron job for deactivating expired ads:', error);
    }
  });
}

export default scheduler