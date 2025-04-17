import { Op } from 'sequelize';
import Chat from '../models/chatModel.js';
import Message from '../models/msgModel.js';
import User from '../models/userModel.js';

const chatService = (io) => {
    io.on('connection', (socket) => {
      console.log(`User connected: ${socket.id}`);
    
      socket.on('userChats', async (userId) => {
        try {
          const chats = await Chat.findAll({
            where: {
              [Op.or]: [   //user find its chats as buyer or seller
                { buyerId: userId },
                { sellerId: userId }
              ]
            }
          });
          // Join each chat room
          chats.forEach(chat => {
            socket.join(`chat_${chat.id}`);
          });
          console.log(`User ${userId} joined their chat rooms`);
        } catch (error) {
          console.error('Error joining chats:', error);
        }
      });
      
      // Handle new messages  //on sent button
      socket.on('sendMessage', async (data) => {
        try {
          const { chatId, senderId, msg } = data;
           // Check if chat already exists
              // const [chatId] = await Chat.findOrCreate({
              //   where: {
              //     buyerId,
              //     sellerId: product.seller,
              //     productId:id
              //   }
              // });

          const newMessage = await Message.create({
            chatId,
            senderId, //might be buyer or seller
            msg,
            status: false
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
          console.log(`Message sent in chat ${chatId}`);
        } catch (error) {
          console.error('Error sending message:', error);
        }
      });
      
      // Handle marking messages as read
    socket.on('markAsRead', async (data) => {
      try {
        const { chatId, userId } = data;
        
        // Update all unread messages sent by the other user
        const result = await Message.update(
          { status: true },
          { 
            where: { 
              chatId,
              senderId: { [Op.ne]: userId },
              status: false
            } 
          }
        );
        
        // // Notify about read status
        // socket.to(`chat_${chatId}`).emit('messagesRead', {
        //   chatId,
        //   readBy: userId,
        //   count: result[0]
        // });
        
        console.log(`${result[0]} messages marked as read in chat ${chatId}`);
      } catch (error) {
        console.error('Error marking messages as read:', error);
      }
    });

      socket.on('disconnect', () => {
        console.log(`User disconnected: ${socket.id}`);
      });
    });
  };

  export default chatService;
