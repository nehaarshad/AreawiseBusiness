import express from 'express';
import reviewControllers from '../controllers/reviewsControllers.js';
const { addReview, updateReview, deleteReview,getReviews } = reviewControllers;
const reviewsRouter = express.Router();

reviewsRouter.get("/getReviews/:id", getReviews);
reviewsRouter.post("/addReview/:id", addReview);
reviewsRouter.put("/updateReview/:id", updateReview);
reviewsRouter.delete("/deleteReview/:id", deleteReview);


export default reviewsRouter;