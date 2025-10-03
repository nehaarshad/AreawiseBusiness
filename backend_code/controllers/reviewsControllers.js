import review from "../models/reviewModel.js";
import Product from "../models/productModel.js";
import User from "../models/userModel.js";
import path from "path";
import dotenv from "dotenv";
import removeImageFromDirectory from "../utils/deleteImageFromDirectory.js";
import { fileURLToPath } from "url";
import { optimizeImage } from "../MiddleWares/uploadimage.js";
const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);
import sendNotificationToUser from "../utils/sendNotification.js";
import image from "../models/imagesModel.js";
dotenv.config();

const addReview = async (req, res) => {

    const {id}=req.params; // Extract user ID from request parameters
    const { productId, rating, comment } = req.body;
    console.log(req.body)
    const userId=parseInt(id); // Parse user ID to integer
    try {

        const reviews=await review.create({
            comment,
            rating,
            userId,
            productId,
            
        });

         if (req.files && req.files.length > 0) {
            const imageRecords = [];
            
            for (const file of req.files) {
                try {
                    const originalPath = file.path;
                    const optimizedFilename = 'optimized-' + file.filename;
                    const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
                    await optimizeImage(originalPath, optimizedPath);
                    const imageUrl = `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`; 
                    imageRecords.push({
                        imagetype: 'reviews', 
                        reviewId: reviews.id,
                        imageUrl
                    });
                    
                } catch (imageError) {
                    console.error('Error processing image:', file.filename, imageError);
                    continue;
                }
            }

            if (imageRecords.length > 0) {
                await image.bulkCreate(imageRecords);
            }
        }
        
        const product=await Product.findOne({where:{id:productId}});

         const allReviews = await review.findAll({
            where: { productId },
            include: [
                {
                    model: Product,
                }
            ]
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


             const sellerId = product.seller;
             const notificationMessage = `New comment added on your product ${product.name}`;

             if (req.io && req.userSockets) {
             await sendNotificationToUser(req.io, req.userSockets, sellerId, notificationMessage);
             }

              const reviewWithImages = await review.findOne({
            where: { id: reviews.id },
            include: [
                {
                    model: image,
                    where: { reviewId: reviews.id },
                    required: false
                }
            ]
        });
        res.status(201).json(reviewWithImages);
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
                include:[
                    {
                                model: image,
                                where: { imagetype: "reviews" },
                                required: false
                            },
                     {
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
        if (req.files && req.files.length > 0) {
            // Remove previous images
            const oldImages = await image.findAll({
                where: { imagetype: 'reviews', reviewId: id }
            });

            // Delete old image files from filesystem
            for (const oldImage of oldImages) {
                try {
                    const oldPath = path.join(dirname, '..', 'uploads', path.basename(oldImage.imageUrl));
                    if (fs.existsSync(oldPath)) {
                        fs.unlinkSync(oldPath);
                    }
                } catch (deleteError) {
                    console.error('Error deleting old image files:', deleteError);
                }
            }
            // Delete old image records from database
            await image.destroy({
                where: { imagetype: 'reviews', reviewId: id }
            });

            // Process new images
            const imageRecords = [];
            for (const file of req.files) {
                try {
                    const originalPath = file.path;
                    const optimizedFilename = 'optimized-' + file.filename;
                    const optimizedPath = path.join(dirname, '..', 'uploads', optimizedFilename);
                    
                    // Optimize the image
                    await optimizeImage(originalPath, optimizedPath);
                    
                    imageRecords.push({
                        imagetype: 'reviews',
                        reviewId: id,
                        imageUrl: `${process.env.baseUrl}/backend_code/uploads/${optimizedFilename}`,
                     });
                    
                } catch (imageError) {
                    console.error('Error processing image during update:', file.filename, imageError);
                    continue;
                }
            }

            if (imageRecords.length > 0) {
                await image.bulkCreate(imageRecords);
            }
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
        
                   const reviewsImage = await image.findAll({
                        where: {  reviewId: id }
                    });
                    if(reviewsImage){
                      await Promise.all(reviewsImage.map(img => removeImageFromDirectory(img.imageUrl)));
                    }
                  await image.destroy({where:{imagetype:'reviews',reviewId:id}});
        await reviews.destroy();

        res.status(201).json({message:"Review Deleted Successfully"});

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error" });
    }
}

export default { addReview, updateReview, deleteReview ,getReviews };