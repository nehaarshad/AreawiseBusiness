import Chat from '../models/chatModel.js';
import Message from '../models/msgModel.js';
import User from '../models/userModel.js';
import Product from '../models/productModel.js';
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
            model: Image,
            where: { imagetype: 'user' },
            required: false,
          }]
        },
        {
          model: Product,
          include: [{
            model: Image,
            where: { imagetype: 'product' },
            required: false,
          }]
        },
        {
          model: Message,
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
            model: Image,
            where: { imagetype: 'user' },
            required: false,
          }]
        },
        {
          model: Product,
          include: [{
            model: Image,
            where: { imagetype: 'product' },
            required: false,
          }]
        },
        {
          model: Message,
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
    
    // Get product to find seller
    const product = await Product.findByPk(id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    
    // Check if chat already exists
    const [Chatting] = await Chat.findOrCreate({
      where: {
        buyerId,
        sellerId: product.seller,
        productId:id
      }
    });
    res.status(201).json(Chatting);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
export default {getChatsAsBuyer,getChatsAsSeller,createChat,getChatMessages};