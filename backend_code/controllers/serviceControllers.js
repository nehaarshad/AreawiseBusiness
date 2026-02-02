import dotenv from "dotenv" 
import sendNotificationToUser from "../utils/sendNotification.js";
import path from "path";
import { fileURLToPath } from "url";
import { optimizeImage } from "../MiddleWares/uploadimage.js";
import fs, { stat } from "fs";
const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);
dotenv.config();
import User from "../models/userModel.js";
import removeImageFromDirectory from "../utils/deleteImageFromDirectory.js";
import services from "../models/servicesModel.js";
import ServiceProviders from "../models/serviceProvidersModel.js";
import ServiceDetails from "../models/serviceDetailsModel.js";

const addService = async (req, res) => {
    try {
        const { name, status} = req.body;
        const images=req.file;

        let imageUrl;
            const originalPath = images.path;
            const optimizedFilename = 'optimized-' + images.filename;
            const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
            
            // Optimize the image
            await optimizeImage(originalPath, optimizedPath);
            
            imageUrl = `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`;

        const newService = await services.create({
            name,
            imageUrl,
            status,
        });


        if(status!="Active"){
           const admins = await User.findAll({where:{role:'Admin'}}); 
           const adminNotificationMessage = `A new request to add "${newService.name || 'Service'}" Service in the app. Please review and approve.`;

           for(const admin of admins){
              if (req.io && req.userSockets) {
               await sendNotificationToUser(req.io, req.userSockets, admin.id, adminNotificationMessage); //adminId
           }
           }

        }
       
        res.status(201).json(newService);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};

//list view of all services
const getallservices=async(req,res)=>{
    try {
        const service=await services.findAll({
             order: [['createdAt', 'DESC']], 
            include: {
                model:ServiceProviders,
                include:{
                    model:ServiceDetails,
                }
            },
        
        });
        console.log(service);
        res.json(service);
    } catch (error) {
        console.log(error);
        res.json({error:"Failed to find services!"})
    }
}

const getServiceById=async(req,res)=>{
    try {
        const {id}=req.params;
        const service=await services.findByPk(id,{
            include:{
                model:ServiceProviders,
                include:{
                    model:ServiceDetails,
                }
            },
        });
        if(!service){
            return res.json({error:"service not Exit"});
          }
        console.log(service);
        res.json(service);
    } catch (error) {
        console.log(error);
        res.json({error:"Failed to find service!"})
    }   
}

const updateservice=async(req,res)=>{  
    try {
        const {id}=req.params;
        const {name, status}=req.body;
        const images=req.file;
        let imageUrl;
        const service = await services.findByPk(id);
            if (!service) {
                return res.status(404).json({ error: 'Service not found!' });
            }
            
            if (images) {

            // Delete old image files from filesystem
                    const oldPath = path.join(dirname, '..', 'uploads', path.basename(service.imageUrl));
                    if (fs.existsSync(oldPath)) {
                        fs.unlinkSync(oldPath);
                    }
            
                    const originalPath = images.path;
                    const optimizedFilename = 'optimized-' + images.filename;
                    const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
                    
                    // Optimize the image
                    await optimizeImage(originalPath, optimizedPath);
                    
                    imageUrl = `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`;
                    
        }
    
            const updatedservice = {
                name: name || service.name,
                status: status || service.status,
               imageUrl: imageUrl || service.imageUrl,
            };
           

          await service.update(updatedservice);

        res.json({
            success:true,
            message:" service updated Successfully",
            service: updatedservice
        })
      
    } catch (error) {
        console.log(error);
        res.json({error:" service  FAILED TO UPDATE!"})
    }
}

const updateServiceStatus=async(req,res)=>{  
    try {
        const {id}=req.params;
        const {status}=req.body;
        const service = await services.findByPk(id);
            if (!service) {
                return res.status(404).json({ error: 'Service not found!' });
            }
            const updatedservice = {
                status: status || service.status,
            };

             await service.update(updatedservice);

         
        res.json({
            success:true,
            message:" service updated Successfully",
        })
      
    } catch (error) {
        console.log(error);
        res.json({error:" service  FAILED TO UPDATE!"})
    }
}

const deleteServicebyid=async(req,res)=>{
    try {
        const {id}=req.params;
        const service=await services.findByPk(id);
          if(!service){
            return res.json({error:"service not Exit"});
          } 
        await removeImageFromDirectory(service.imageUrl);
                              
           const serviceId = id;
          const providers=await ServiceProviders.findAll({where:{serviceId}});  //providesr list
            if(providers.length>0){
                for(const provider of providers){
                
                        try {
                            await removeImageFromDirectory(provider.ImageUrl); //provider image deletion from directory
                        } catch (error) {
                            console.log(error);
                        }

                        const providerId = provider.id;
                        const serviceDetails = await ServiceDetails.findAll({ where: { providerId } }); //related service provider details
                        for (const detail of serviceDetails) {
                            await detail.destroy();
                        }

                        //notify provider about deletion
                        const providerNotificationMessage = `"${service.name || 'Service'}" Service and related providers details have been deleted by the admin.`;


                        if (req.io && req.userSockets) {
                            await sendNotificationToUser(req.io, req.userSockets, providerId, providerNotificationMessage);
                        }

                        //delete provider

                        await provider.destroy();
                                              
             }
            }
        await service.destroy();
         res.json({message:"service Deleted Successfully"});
  } catch (error) {
        console.log(error);
        res.json({error:"service  FAILED TO DELETE!"})
    }
}

export default {addService, getallservices,getServiceById, updateservice, deleteServicebyid, updateServiceStatus};