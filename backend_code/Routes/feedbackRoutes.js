import express from 'express';
import feedbackControllers from '../controllers/feebackController.js';
const { submitFeedback, getFeedback } = feedbackControllers;
const feedbackRouter = express.Router();

feedbackRouter.post("/submitFeedback", submitFeedback);
feedbackRouter.get("/getFeedback", getFeedback);


export default feedbackRouter;