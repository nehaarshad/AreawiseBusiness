import express from 'express';
import chatControllers from '../controllers/chatControllers.js';
import auth from '../MiddleWares/authMiddleware.js';

const {getChatsAsBuyer,getChatsAsSeller,createChat,getChatMessages,deleteChat,markMessagesAsRead} = chatControllers;
const chatRouter = express.Router();

// All chat routes need authentication
// chatRouter.use(auth);
chatRouter.get('/getChatsAsSeller/:id', getChatsAsSeller);
chatRouter.get('/getChatsAsBuyer/:id', getChatsAsBuyer);
chatRouter.post('/createChat/:id', createChat);
chatRouter.post('/markMessagesAsRead/:id', markMessagesAsRead);
chatRouter.get('/getChatMessages/:id', getChatMessages);
chatRouter.delete('/deleteChat/:id',deleteChat);

export default chatRouter;