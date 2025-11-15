import express from "express";
import  reminderController  from "../controllers/orderReminderController.js";
const reminderRouter = express.Router();
const {setOrderReminder,deleteOrderReminder}=reminderController;

reminderRouter.post("/setOrderReminder/:id",setOrderReminder);
reminderRouter.delete("/deleteOrderReminder/:id",deleteOrderReminder);

export default reminderRouter;