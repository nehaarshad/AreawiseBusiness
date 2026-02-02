import express from 'express';
import serviceProviderControllers from '../controllers/serviceProviderController.js';
import {upload} from '../MiddleWares/uploadimage.js';
const {addServiceProvider,getAllProvidersOfServices,getAllUserProviders,updateServiceProvider,deleteServiceProviderbyid} = serviceProviderControllers;
const serviceProviderRouter = express.Router();

serviceProviderRouter.post("/addServiceProvider/:id",upload.single('image'),addServiceProvider);
serviceProviderRouter.get("/getAllProvidersOfServices/:id",getAllProvidersOfServices);
serviceProviderRouter.get("/getAllUserProviders/:id",getAllUserProviders);
serviceProviderRouter.put("/updateServiceProvider/:id",upload.single('image'),updateServiceProvider);
serviceProviderRouter.delete("/deleteServiceProviderbyid/:id",deleteServiceProviderbyid);

export default serviceProviderRouter;