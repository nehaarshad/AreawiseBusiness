import User from "./userModel.js";
import Address from "./addressmodel.js";
import shop from "./shopmodel.js";
import Product from "./productModel.js";
import category from "./categoryModel.js";
import subcategory from "./subCategoryModel.js";
import image from "./imagesModel.js";
import cart from "./CartModel.js";
import items from "./cartItemModel.js";
import order from "./orderModel.js";
import wishList from "./wishListModel.js";
import SellerOrder from "./sellerOrderModel.js";
import Ads from "./adsModel.js";
import featured from "./featuredModel.js";
import Chat from "./chatModel.js";
import Message from "./msgModel.js";
import review from "./reviewModel.js";
import sale from "./salesModel.js";
import SellerPaymentAccount from "./sellerAccountModel.js";


const relation = () => {
    //user relation.......
    User.hasOne(Address, {foreignKey: {  name: 'userId', allowNull: false } });
    Address.belongsTo(User, { foreignKey: 'userId' });

    User.hasMany(shop, { foreignKey: {name: 'userId', allowNull: false } });
    shop.belongsTo(User, { foreignKey: 'userId' });

    SellerPaymentAccount.belongsTo(User, { foreignKey: 'sellerId' });
    User.hasMany(SellerPaymentAccount, { foreignKey: 'sellerId' });

    User.hasOne(image,{foreignKey:{name:'UserId',allowNull:false},constraints: false,scope: {imagetype: 'user'},});
    image.belongsTo(User,{foreignKey:{name:"UserId"},constraints: false,scope: {imagetype: 'user'}});

    User.hasMany(Product, { foreignKey: {name: 'seller', allowNull: false } });
    Product.belongsTo(User, { foreignKey: 'seller' });

    User.hasMany(sale, { foreignKey: {name: 'userId', allowNull: false } });
    sale.belongsTo(User, { foreignKey: 'userId' });

    //shop relations.........
    shop.hasMany(Product, { foreignKey: {name: 'shopid', allowNull: false } });
    Product.belongsTo(shop, { foreignKey: 'shopid' });

    shop.hasMany(image,{foreignKey:{name:'ShopId',allowNull:false},constraints: false,scope: {imagetype: 'shop'},});
    image.belongsTo(shop,{foreignKey:{name:'ShopId'},constraints: false,scope: {imagetype: 'shop'}});

    category.hasMany(shop,{foreignKey:{name:'categoryId',allowNull:false}});
    shop.belongsTo(category,{foreignKey:{name:'categoryId'}});

    //product relations.....
    Product.hasMany(image,{foreignKey:{name:'ProductId',allowNull:false},constraints: false,scope: {imagetype: 'product'},});
    image.belongsTo(Product,{foreignKey:{name:'ProductId'},constraints: false,scope: {imagetype: 'product'}});

    sale.belongsTo(Product,{foreignKey:{name:"productId"}});
    Product.hasOne(sale,{foreignKey:{name:"productId"}});

    category.hasMany(subcategory, { foreignKey:{name: 'categoryId'} ,allowNull:false });
    subcategory.belongsTo(category, { foreignKey: {name: 'categoryId'} });

    subcategory.hasMany(Product, { foreignKey: {name: 'subcategoryId'}  ,allowNull:false });
    Product.belongsTo(subcategory, { foreignKey: {name: 'subcategoryId'}});

    category.hasOne(image,{foreignKey:{name:'CategoryId',allowNull:false},constraints: false,scope: {imagetype: 'category'},});
    image.belongsTo(category,{foreignKey:{name:"CategoryId"},constraints: false,scope: {imagetype: 'category'}});

    Product.hasOne(sale,{foreignKey:{name:'productId',allowNull:false}});
    sale.belongsTo(Product,{foreignKey:{name:"productId"}});


    category.hasMany(Product, { foreignKey:{name: 'categoryId'} ,allowNull:false});
    Product.belongsTo(category, { foreignKey:{name: 'categoryId'} });

    //cart management relations
    User.hasMany(cart, { foreignKey: {name: 'UserId', allowNull: false } });
    cart.belongsTo(User, { foreignKey: 'UserId' });

    cart.hasMany(items, { foreignKey: {name: 'cartId', allowNull: false } });
    items.belongsTo(cart, { foreignKey: 'cartId' });

    Product.hasMany(items, { foreignKey: {name: 'productId', allowNull: false } });
    items.belongsTo(Product, { foreignKey: 'productId' });


    //order relations
    // A user (customer) can place multiple seller orders
    User.hasMany(SellerOrder, { foreignKey: {name: 'customerId', allowNull: false }});
    SellerOrder.belongsTo(User, { foreignKey: 'customerId' });

    // A user (seller) can receive multiple seller orders
    User.hasMany(SellerOrder, { foreignKey:  {name:'sellerId',allowNull: false }});
    SellerOrder.belongsTo(User, { foreignKey: 'sellerId' });

    order.hasMany(SellerOrder, { foreignKey:  {name:'orderId',allowNull: false }});
    SellerOrder.belongsTo(order, { foreignKey: 'orderId' });

    // A product can be associated with multiple seller orders
    Product.hasMany(SellerOrder, { foreignKey: {name: 'orderProductId', allowNull: false } });
    SellerOrder.belongsTo(Product, { foreignKey: 'orderProductId' });


    cart.hasOne(order, { foreignKey: {name: 'cartId', allowNull: false } });
    order.belongsTo(cart, { foreignKey: 'cartId' });

    //wishlist relations
    User.hasMany(wishList, { foreignKey: { name: 'userId', allowNull: false } }); //one user have multiple entries based on product IDs
    wishList.belongsTo(User, { foreignKey: 'userId' });
    
    Product.hasMany(wishList, { foreignKey: { name: 'productId', allowNull: false } });//one product added by many users so have many entries
    wishList.belongsTo(Product, { foreignKey: 'productId' });    

    User.hasMany(Ads, { foreignKey: { name: 'sellerId', allowNull: false } });
    Ads.belongsTo(User, { foreignKey: 'sellerId' });

    Ads.hasOne(image, { foreignKey:  { name: 'AdId', allowNull: false } });
    image.belongsTo(Ads, { foreignKey: 'AdId' });

    User.hasMany(featured, { foreignKey: { name: 'userID', allowNull: false } });  //can featured multiple products
    featured.belongsTo(User, { foreignKey: 'userID' });

    Product.hasMany(featured, { foreignKey: { name: 'productID', allowNull: false } });  // can featured multiple times
    featured.belongsTo(Product, { foreignKey: 'productID' });


    //chat and message relations
    User.hasMany(Chat, { foreignKey: { name: 'buyerId', allowNull: false } });
    Chat.belongsTo(User, { foreignKey: 'buyerId' });

    User.hasMany(Chat, { foreignKey: { name: 'sellerId', allowNull: false } });
    Chat.belongsTo(User, { foreignKey: 'sellerId' });

    User.hasMany(Message, { foreignKey: { name: 'senderId', allowNull: false } });
    Message.belongsTo(User, { foreignKey: 'senderId' });

    Product.hasMany(Chat, { foreignKey: { name: 'productId', allowNull: false } });
    Chat.belongsTo(Product, { foreignKey: 'productId' });

    Chat.hasMany(Message, { foreignKey: { name: 'chatId', allowNull: false }});
    Message.belongsTo(Chat, { foreignKey: 'chatId' });

    //review relations
    User.hasMany(review, { foreignKey: {name: 'userId', allowNull: false } });
    review.belongsTo(User, { foreignKey: 'userId' });

    Product.hasMany(review, { foreignKey: {name: 'productId', allowNull: false } });
    review.belongsTo(Product, { foreignKey: 'productId' });
};


export default relation;
