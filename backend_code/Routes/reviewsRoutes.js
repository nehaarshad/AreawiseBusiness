import express from 'express';
import reviewControllers from '../controllers/reviewsControllers.js';
import { upload } from "../MiddleWares/uploadimage.js"; 
const { addReview, updateReview, deleteReview,getReviews } = reviewControllers;
const reviewsRouter = express.Router();

reviewsRouter.get("/getReviews/:id", getReviews);
reviewsRouter.post("/addReview/:id", upload.array('image', 3), addReview);
reviewsRouter.put("/updateReview/:id", upload.array('image', 3), updateReview);
reviewsRouter.delete("/deleteReview/:id", deleteReview);


export default reviewsRouter;