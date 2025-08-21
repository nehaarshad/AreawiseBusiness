const makePayment = async (orderId, paymentMethod, paymentDetails = {}) => { ///1,jazzcash,{customerdetails}
    try {
        const order = await order.findByPk(orderId, {
            include: [{
                model: cart,
                include: [{
                    model: items,
                    include: [Product]
                }]
            }]
        });

        if (!order) {
            throw new Error('Order not found');
        }

        // Group seller items to create its payments 
        const sellerGroups = {}; //{1:[p1,p2],2:[p3]}
        
        for (const item of order.Cart.CartItems) { 
            const sellerId = item.Product.seller;
            if (!sellerGroups[sellerId]) { //key->sellerID
                sellerGroups[sellerId] = []; //value->seller items array in the order
            }
            sellerGroups[sellerId].push(item);
        }

        const payments = [];

        // Create payment record for each seller
        for (const [sellerId, items] of Object.entries(sellerGroups)) {
            const sellerAmount = items.reduce((total, item) => {
                return total + (item.Product.price * item.quantity);
            }, 0);

            // Get seller's payment account info
            const sellerAccount = await SellerAccount.findOne({
                where: { sellerId }
            });

            //to record overall payment transaction
            const payment = await transactions.create({
                orderId,
                sellerId: parseInt(sellerId),
                customerId: order.Cart.UserId,
                amount: sellerAmount,
                paymentMethod,
                paymentDetails,
                sellerAccountInfo: sellerAccount ? {
                    accountType: sellerAccount.accountType,
                    accountNumber: sellerAccount.accountNumber,
                    accountHolderName: sellerAccount.accountHolderName,
                    bankName: sellerAccount.bankName
                } : null
            });

            payments.push(payment);
        }

        // Update order with payment method
        await order.update({
            paymentMethod,
            paymentStatus: paymentMethod === 'cash' ? 'pending' : 'paid'
        });

        return payments;

    } catch (error) {
        console.error('Initialize Payment Error:', error);
        throw error;
    }
};

