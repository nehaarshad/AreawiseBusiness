import Notification from "../models/notifications.js";

const sendNotificationToUser = async (io, userSockets, userId, message) => {
  try {
    const newNotification = await Notification.create({
      userId,
      message
    });

    // Get the socket ID for the user
    const socketId = userSockets.get(userId.toString());
    
    if (socketId) {
      // Emit directly to the user's socket
      io.to(socketId).emit('receiveNotification', newNotification);
      console.log(`Notification sent to user ${userId}: ${message}`);
    } else {
      console.log(`User ${userId} is not connected - notification saved to database`);
    }

  } catch (error) {
    console.error('Error sending notification:', error);
    throw error;
  }
}

export default sendNotificationToUser;
