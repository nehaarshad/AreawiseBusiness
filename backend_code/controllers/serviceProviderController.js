import dotenv from "dotenv" 
import sendNotificationToUser from "../utils/sendNotification.js";
import path from "path";
import { fileURLToPath } from "url";
import { optimizeImage } from "../MiddleWares/uploadimage.js";
import fs, { stat } from "fs";
const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);
dotenv.config();
import removeImageFromDirectory from "../utils/deleteImageFromDirectory.js";
import services from "../models/servicesModel.js";
import ServiceProviders from "../models/serviceProvidersModel.js";
import ServiceDetails from "../models/serviceDetailsModel.js";

const addServiceProvider = async (req, res) => {
    try {
        const {id}=req.params; //userId
        const { providerName, email,contactnumber,experience ,OpenHours,location,serviceID ,serviceDetails} = req.body;
        const images=req.file;
        console.log(req.body);
        let ImageUrl;
            const originalPath = images.path;
            const optimizedFilename = 'optimized-' + images.filename;
            const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
            
            // Optimize the image
            await optimizeImage(originalPath, optimizedPath);
            
            ImageUrl = `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`;

            const serviceid=parseInt(serviceID);
        const service=await services.findByPk(serviceid);
        if(!service){
            console.log("Service not found!");
            return res.json({error:"Service not found!",message:"Please select valid service"});
        }
            const providerID=parseInt(id);
            console.log("provider id:",providerID);
        const newServiceProvider = await ServiceProviders.create({
            providerName,
            providerID,
            email,
            ImageUrl,
            contactnumber,
            experience,
            OpenHours,
            location,
            serviceId:service.id
        });

        console.log("service details:");
        console.log(serviceDetails);
        let detail;
         try { 
             detail = Array.isArray(serviceDetails) ? serviceDetails : JSON.parse(serviceDetails); 
            } catch (err) {
                return res.status(400).json({ error: "Invalid serviceDetails format" });
            }

        const formattedDetails = detail.map(d => (
            { serviceDetails: d.detail,
              cost: d.cost, 
              providerId: newServiceProvider.id 
            }
        ));
          console.log("formated service details:");
        console.log(formattedDetails);
            await ServiceDetails.bulkCreate(formattedDetails);
 console.log("Service details added successfully.", newServiceProvider, formattedDetails);
        res.status(201).json(newServiceProvider);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal Server Error" });
    }
};

//list view of all services
const getAllProvidersOfServices=async(req,res)=>{
    try {
        const {id}=req.params; //serviceId
        const serviceProvider=await services.findByPk(id,{
             order: [['createdAt', 'DESC']], 
            include: [
                {
                    model:ServiceProviders,
                    include:{
                        model:ServiceDetails,
                    }
                }

            ]},);

        console.log(serviceProvider);
        res.json(serviceProvider);
    } catch (error) {
        console.log(error);
        res.json({error:"Failed to find services!"})
    }
}

const getAllUserProviders=async(req,res)=>{
    try {
        const {id}=req.params; //iuserId
        const serviceProvider=await ServiceProviders.findAll({
             order: [['createdAt', 'DESC']],    
            where:{providerID:id},
            include: {
                model:ServiceDetails,
            }
        });

        if(!serviceProvider){
            return res.json({message:"services not Exit"});
          }
        console.log(serviceProvider);
        res.json(serviceProvider);
    } catch (error) {
        console.log(error);
        res.json({error:"Failed to find user service!"})
    }   
}

const updateServiceProvider=async(req,res)=>{  
    try {
        const {id}=req.params; //providerId
      const { providerName, email,contactnumber,experience ,OpenHours,location ,serviceDetails} = req.body;
         console.log(req.params,req.body);   
       const images=req.file;
        let ImageUrl;
        const provider = await ServiceProviders.findByPk(id);
            if (!provider) {
                console.log("Provider not found!");
                return res.status(404).json({ error: 'provider not found!' });
            }
            
            await ServiceDetails.destroy({ where: { providerId: parseInt(id) } });

            if (images) {

            // Delete old image files from filesystem
                    const oldPath = path.join(dirname, '..', 'uploads', path.basename(provider.ImageUrl));
                    if (fs.existsSync(oldPath)) {
                        fs.unlinkSync(oldPath);
                    }
            
                    const originalPath = images.path;
                    const optimizedFilename = 'optimized-' + images.filename;
                    const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
                    
                    // Optimize the image
                    await optimizeImage(originalPath, optimizedPath);
                    
                    ImageUrl = `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`;
                    
        }
    
            const updatedServiceProvider = {
                providerName: providerName || provider.providerName,
                email: email || provider.email,
                contactnumber: contactnumber || provider.contactnumber,
                experience: experience || provider.experience,
                OpenHours: OpenHours || provider.OpenHours,
                ImageUrl: ImageUrl || provider.imageUrl,
                location: location || provider.location,
            };
           
                   let detail;
         try { 
             detail = Array.isArray(serviceDetails) ? serviceDetails : JSON.parse(serviceDetails); 
            } catch (err) {
                return res.status(400).json({ error: "Invalid serviceDetails format" });
            }

        const formattedDetails = detail.map(d => (
            { serviceDetails: d.detail,
              cost: d.cost, 
              providerId: provider.id

            }
        ));
          console.log("formated service details:");
        console.log(formattedDetails);
            await ServiceDetails.bulkCreate(formattedDetails);

          await provider.update(updatedServiceProvider);
        res.json(updatedServiceProvider);
        
      
    } catch (error) {
        console.log(error);
        res.json({error:" service  FAILED TO UPDATE!"})
    }
}


const deleteServiceProviderbyid=async(req,res)=>{
    try {
        const {id}=req.params;
        console.log("deleting service provider with id:",id);
        const provider=await ServiceProviders.findByPk(id);
          if(!provider){
            console.log("provider not Exit");
            return res.json({error:"provider not Exit"});
          } 
        await removeImageFromDirectory(provider.ImageUrl);
                              
           const providerId = provider.id;
                        const serviceDetails = await ServiceDetails.findAll({ where: { providerId } }); //related service provider details
                        for (const detail of serviceDetails) {
                            await detail.destroy();
                        }

                        //notify provider about deletion
                        const providerNotificationMessage = `"${provider.providerName || 'Service'}" Service and related providers details have been deleted by the admin.`;


                        if (req.io && req.userSockets) {
                            await sendNotificationToUser(req.io, req.userSockets, providerId, providerNotificationMessage);
                        }

                        //delete provider

                        await provider.destroy();
         res.json({message:"service Deleted Successfully"});
  } catch (error) {
        console.log(error);
        res.json({error:"service  FAILED TO DELETE!"})
    }
}

export default {addServiceProvider, getAllProvidersOfServices, getAllUserProviders, updateServiceProvider, deleteServiceProviderbyid};