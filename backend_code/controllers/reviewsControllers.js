import review from "../models/reviewModel.js";
import Product from "../models/productModel.js";
import User from "../models/userModel.js";
import { parse } from "dotenv";
import image from "../models/imagesModel.js";

const addReview = async (req, res) => {

    const {id}=req.params; // Extract user ID from request parameters
    const { productId, rating, comment } = req.body;
    const userId=parseInt(id); // Parse user ID to integer
    try {

        const reviews=await review.create({
            comment,
            rating,
            userId,
            productId,
            
        });

         const allReviews = await review.findAll({
            where: { productId }
        });

        const totalRating = allReviews.reduce((acc, curr) => acc + curr.rating, 0); //average number of product reviews
        const avgRating = totalRating / allReviews.length;

       // Update the product model
       await Product.update(
        {
            ratings: avgRating.toFixed(1), // values to update
        },
        {
            where: { id: productId } // condition to find the product
        }
        
    );

        res.status(201).json(reviews);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error" });
    }
}

const getReviews = async (req, res) => {
    
        const {id}=req.params; // Extract product ID from request parameters
        try {
            const reviews = await review.findAll({
                where: { productId: id },
                 order: [['createdAt', 'DESC']], 
                include:[ {
                    model: Product,
                },
                {
                    model: User,
                    include: {
                                                model: image,
                                                where: { imagetype: "user" },
                                                required: false
                                            }
                }],
            });
            res.status(200).json(reviews);
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: "Server error" });
        }
    }

const updateReview = async (req, res) => {

    const {id}=req.params; // Extract review ID from request parameters
    const { comment } = req.body;
    try {

        const reviews=await review.findByPk(id);
        if (!reviews) {
            return res.status(404).json({ message: "Review not found" });
        }
        reviews.comment = comment; // Update the comment field
        await reviews.save(); // Save the changes to the database

        res.status(201).json(reviews);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error" });
    }
}

const deleteReview = async (req, res) => {

    const {id}=req.params; // Extract review ID from request parameters
    try {

        const reviews=await review.findByPk(id);

        await reviews.destroy();

        res.status(201).json({message:"Review Deleted Successfully"});

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error" });
    }
}

export default { addReview, updateReview, deleteReview ,getReviews };