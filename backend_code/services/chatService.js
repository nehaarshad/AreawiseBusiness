import { Op } from 'sequelize';
import Chat from '../models/chatModel.js';
import Message from '../models/msgModel.js';
import User from '../models/userModel.js';

const chatService = (io) => {
    io.on('connection', (socket) => {
      console.log(`User connected: ${socket.id}`);
    
      // Join room for each chat the user is part of
      socket.on('joinChats', async (userId) => {
        try {
          const chats = await Chat.findAll({
            where: {
              [Op.or]: [   //user find its chats as buyer or seller
                { buyerId: userId },
                { sellerId: userId }
              ]
            }
          });
          
          chats.forEach(chat => {
            socket.join(`chat_${chat.id}`);
          });
        } catch (error) {
          console.error('Error joining chats:', error);
        }
      });
      
      // Handle new messages
      socket.on('sendMessage', async ({ chatId, senderId, message }) => {
        try {
          const newMessage = await Message.create({
            chatId,
            senderId,
            msg: message
          });
          
          // Update chat's last message timestamp
          await Chat.update(
            { lastMessageAt: new Date() },
            { where: { id: chatId } }
          );
          
          // Get full message details with sender info
          const fullMessage = await Message.findByPk(newMessage.id, {
            include: [{
              model: User,
            }]
          });
          
          // Emit to all participants in the chat
          io.to(`chat_${chatId}`).emit('receiveMessage', fullMessage);
        } catch (error) {
          console.error('Error sending message:', error);
        }
      });
      
      socket.on('disconnect', () => {
        console.log(`User disconnected: ${socket.id}`);
      });
    });
  };

  export default chatService;
