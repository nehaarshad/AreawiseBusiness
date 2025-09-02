import feedback from "../models/feedbackModel.js";


const submitFeedback = async (req, res) => {

    const { comment, email } = req.body;
    console.log("Feedback submitted:", { comment, email });
    try {
        const newFeedback = await feedback.create({ comment, email });
        res.status(201).json(newFeedback);
    } catch (err) {
        res.status(500).json(err);
    }
};

const getFeedback = async (req, res) => {
   
    try {
        const feedbackList = await feedback.findAll({
            order: [['createdAt', 'DESC']]
        });
        res.status(200).json(feedbackList);
    } catch (err) {
        res.status(500).json(err);
    }
};


export default { submitFeedback, getFeedback };