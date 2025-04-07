import Ads from "../models/adsModel.js";
import image from "../models/imagesModel.js";
import dotenv from "dotenv";
dotenv.config();
  
const createAd=async(req,res)=>{
try {
    const {id}=req.params; //userId
    const {expire_at}=req.body; 


//     const expire_at = new Date();  //current date and time
// //
// //     If today is January 28, 2025, and days is 5, it will calculate January 28 + 5 = February 2, 2025
//       //retrive current date of month and add the days after which ad expired
//    expire_at.setDate(expire_at.getDate() + parseInt(expireIn)); //modify current date with future date when ad will expire

    if (req.file) {
        const imageUrl = `${process.env.baseUrl}/backend_code/uploads/${req.file.filename}`; 
           const ads= await Ads.create({sellerId:id,expire_at,is_active: true});
            await image.create({ imagetype: 'ad', AdId: ads.id, imageUrl });
            return res.status(201).json({
                mesaage:"AD Created Successfully"
            })
    }
    return res.status(400).json({
        error: "An image is required for the ad"
      });
} catch (error) {
    console.log(error);
    res.json({error:"Failed to create AD"})
}
}

const getAllAds=async(req,res)=>{
    try {
        const ads=await Ads.findAll({
            where:{is_active:true},
            include:{
                model:image,
                where:{imagetype:"ad"},
                required:true //all ads have images
            },
        });
        res.status(200).json(ads)
        console.log(ads)
    } catch (error) {
        console.log(error);
        res.status(500).json({
            message:"Failed to get ADs"
        })
    }
}

const getUserAds=async(req,res)=>{
    try {
        const {id}=req.params;
        const ads=await Ads.findAll({ 
            where:{sellerId:id,is_active:true},
            include:{
                model:image,
                where:{imagetype:"ad"},
                required:true //all ads have images
            },
        });
        if(!ads){
            res.json({mesaage:"User has no Active ADs"})  
        }
        res.status(200).json(ads)  
    } catch (error) {
        console.log(error);
        res.status(500).json({
            message:"Failed to get User ADs"
        })
    }
}

const deleteAd=async(req,res)=>{
    try {
        const {id}=req.params;
        const ads = await Ads.findByPk(id);
        if (!ads) {
            return res.json({ error: "AD not Exit" });
        }
        const adimage=await image.destroy({where:{imagetype:"ad",AdId:id}})
        if(adimage>0){
            console.log(`${adimage} Images of this AD deleted`)
        }
        await ads.destroy();
        res.json({
            message: "AD removed Successfully",
        })
    } catch (error) {
        console.log(error);
        res.json({error:"Failed to DELETE AD"})
    }
}

export default {createAd,getAllAds,getUserAds,deleteAd}