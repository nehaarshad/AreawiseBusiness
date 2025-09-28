import Ads from "../models/adsModel.js";
import image from "../models/imagesModel.js";
import path from "path";
import dotenv from "dotenv";
import { fileURLToPath } from "url";
import { optimizeImage } from "../MiddleWares/uploadimage.js";
const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);
dotenv.config();
import removeImageFromDirectory from "../utils/deleteImageFromDirectory.js";
  
const createAd=async(req,res)=>{
try {
    const {id}=req.params; //userId
    const {expire_at}=req.body; 


  if (req.file) {
        try {
                            const originalPath = req.file.path;
                            const optimizedFilename = 'optimized-' + req.file.filename;
                            const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
                            
                            // Optimize the image
                            await optimizeImage(originalPath, optimizedPath);
                            const imageUrl = `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`; 
           const ads= await Ads.create({sellerId:id,expire_at,is_active: true});
            await image.create({ imagetype: 'ad', AdId: ads.id, imageUrl });
            return res.status(201).json({
                message:"AD Created Successfully"
            });

                        } catch (imageError) {
                            console.error('Error processing image:', req.file.filename, imageError);
                        
                        }
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
          const oldImages = await image.findAll({
                        where: { imagetype: 'ad', AdId: id }
                    });
        
                    // Delete old image files from filesystem
                    for (const oldImage of oldImages) {
                       await removeImageFromDirectory(oldImage.imageUrl);
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