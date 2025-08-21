import Chat from '../models/chatModel.js';
import Message from '../models/msgModel.js';
import User from '../models/userModel.js';
import image from '../models/imagesModel.js';
import Product from '../models/productModel.js';
import sendNotificationToUser from '../utils/sendNotification.js';
import { Op } from 'sequelize';

// Get all chats for a user (separated by buyer/seller roles)
 const getChatsAsBuyer = async (req, res) => {
  try {
    const {id} = req.params;
    const Chats = await Chat.findAll({
      where: { buyerId: id },
      include: [
        {
          model: User,
          include: [{
            model: image,
            where: { imagetype: 'user' },
            required: false,
          }]
        },
        {
          model: Product,
          include: [{
            model: image,
            where: { imagetype: 'product' },
            required: false,
          }]
        },
        {
          model: Message,
          limit:1,  //for chatListView
          order: [['createdAt', 'DESC']],
        }
      ],
      order: [['lastMessageAt', 'DESC']]
    });
    

    res.status(200).json(Chats);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error'});
  }
};

const getChatsAsSeller = async (req, res) => {
  try {
    const {id} = req.params;
    const Chats = await Chat.findAll({
      where: { sellerId: id },
      include: [
        {
          model: User,
          include: [{
            model: image,
            where: { imagetype: 'user' },
            required: false,
          }]
        },
        {
          model: Product,
          include: [{
            model: image,
            where: { imagetype: 'product' },
            required: false,
          }]
        },
        {
          model: Message,
          limit:1,
          order: [['createdAt', 'DESC']],
        }
      ],
      order: [['lastMessageAt', 'DESC']]
    });
    

    res.status(200).json( Chats);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error'});
  }
};

// Get messages for a specific chat
 const getChatMessages = async (req, res) => {
  try {
    const { id } = req.params;
    
    const messages = await Message.findAll({
      where: { chatId:id },
      include: [{
        model: User,
      }],
      order: [['createdAt', 'ASC']]
    });
    
    res.status(200).json(messages);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Create new chat (from product page)
 const createChat = async (req, res) => {
  try {
    const { id } = req.params; // Product ID
    const {buyerId} = req.body;
    console.log(`buyerID ${buyerId}`)
    // Get product to find seller
    const product = await Product.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    
    if (buyerId === product.seller) {
  return res.status(400).json({ message: 'Cannot create chat with yourself' });
}
    // Check if chat already exists
    let Chats = await Chat.findOne({
      where: {
        buyerId,
        sellerId: product.seller,
        productId:id
      },
      include: [
        {
          model: User,
          include: [{
            model: image,
            where: { imagetype: 'user' },
            required: false,
          }]
        },
        {
          model: Product,
          include: [{
            model: image,
            where: { imagetype: 'product' },
            required: false,
          }]
        },
        {
          model: Message,
          limit:1,
          order: [['createdAt', 'DESC']],
        }
      ],
      order: [['lastMessageAt', 'DESC']]
    });
    // If chat doesn't exist, create a new one
    if (!Chats) {
    const  newChat = await Chat.create({
        buyerId,
        sellerId: product.seller,
        productId:id,
        lastMessageAt: new Date()
      });
      
      // Fetch with associations to match existing pattern
      Chats = await Chat.findByPk(newChat.id, {
        include: [
          {
            model: Message,
            limit: 1,
            order: [['createdAt', 'DESC']],
          },
          {
            model: Product,
            include: [
              {
                model: image,
                limit: 1
              }
            ]
          }
        ]
      });
    }

      const sellerId = product.seller; 
                     const NotificationMessage = `New chat on product #"${product.id}"`;
                      if (req.io && req.userSockets) {
                         await sendNotificationToUser(req.io, req.userSockets, sellerId, NotificationMessage);
                         }
    res.status(201).json(Chats);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

const deleteChat=async(req,res)=>{
  try {
    const {id}=req.params;
    const chat=await Chat.findByPk(id)
      if(!chat){
        return res.json({error:"Chat not Exit"});
      } 
      const chatId=chat.id;
      const chatMessages=await Message.destroy({where:{chatId}});
        if(chatMessages>0){
            console.log(`${chatMessages} messages of this chat is deleted`)
        }
           
     await chat.destroy();
     res.json({
        success:true,
        message:"Chat Deleted Successfully"
     });

} catch (error) {
    console.log(error);
    return res.json({error:"ERROR!"});
}

}

 const markMessagesAsRead = async (req, res) => {
  try {
    const { chatId, userId } = req.body;
    
    if (!chatId || !userId) {
      return res.status(400).json({ message: 'Missing required fields' });
    }
    
    // Update all unread messages sent by others
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
    
    res.status(200).json({ 
      message: 'Messages marked as read',
      updatedCount: result[0]
    });
  } catch (error) {
    console.error('Error marking messages as read:', error);
    res.status(500).json({ message: 'Failed to mark messages', error: error.message });
  }
};

export default {getChatsAsBuyer,getChatsAsSeller,createChat,getChatMessages,deleteChat,markMessagesAsRead};