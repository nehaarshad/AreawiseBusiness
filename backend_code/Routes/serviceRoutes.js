import express from 'express';
import serviceControllers from '../controllers/serviceControllers.js';
import {upload} from '../MiddleWares/uploadimage.js';
const {addService,getallservices,updateservice,deleteServicebyid,getServiceById,updateServiceStatus} = serviceControllers;
const serviceRouter = express.Router();

serviceRouter.post("/addservice",upload.single('image'),addService);
serviceRouter.get("/getallservices",getallservices);
serviceRouter.get("/getServiceById/:id",getServiceById);
serviceRouter.put("/updateservice/:id",upload.single('image'),updateservice);
serviceRouter.put("/updateServiceStatus/:id",updateServiceStatus);
serviceRouter.delete("/deleteServicebyid/:id",deleteServicebyid);

export default serviceRouter;