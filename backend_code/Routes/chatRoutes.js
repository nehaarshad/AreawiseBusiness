import express from 'express';
import chatControllers from '../controllers/chatControllers.js';
import auth from '../MiddleWares/authMiddleware.js';

const {getChatsAsBuyer,getChatsAsSeller,createChat,getChatMessages} = chatControllers;
const chatRouter = express.Router();

// All chat routes need authentication
chatRouter.use(auth);
chatRouter.get('/chats/:id', getChatsAsSeller);
chatRouter.get('/chats/:id', getChatsAsBuyer);
chatRouter.post('/chats/:id', createChat);
chatRouter.get('/chats/:id', getChatMessages);

export default chatRouter;