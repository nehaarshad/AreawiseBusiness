import express from 'express';
import addressControllers from '../controllers/addressControllers.js';
const { addAddress, getAddress, updateAddress, deleteAddress } = addressControllers;
const addressRouter = express.Router();

addressRouter.post("/addAddress/:id", addAddress);
addressRouter.get("/getAddress/:id", getAddress);
addressRouter.put("/updateAddress/:id", updateAddress);
addressRouter.delete("/deleteAddress/:id", deleteAddress);


export default addressRouter;