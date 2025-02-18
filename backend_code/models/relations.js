import User from "./userModel.js";
import Address from "./addressmodel.js";
import shop from "./shopmodel.js";
import Product from "./productmodel.js";
import category from "./categoryModel.js";
import subcategory from "./subCategoryModel.js";
import image from "./imagesModel.js";
import cart from "./CartModel.js";
import items from "./cartItemModel.js";
import order from "./orderModel.js";

const relation = () => {
    //user relation.......
    User.hasOne(Address, {foreignKey: {  name: 'userId', allowNull: false } });
    Address.belongsTo(User, { foreignKey: 'userId' });

    User.hasMany(shop, { foreignKey: {name: 'userId', allowNull: false } });
    shop.belongsTo(User, { foreignKey: 'userId' });

    User.hasOne(image,{foreignKey:{name:'UserId',allowNull:false},constraints: false,scope: {imagetype: 'user'},});
    image.belongsTo(User,{foreignKey:{name:"UserId"},constraints: false,scope: {imagetype: 'user'}});

    User.hasMany(Product, { foreignKey: {name: 'seller', allowNull: false } });
    Product.belongsTo(User, { foreignKey: 'seller' });

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

    
    category.hasMany(subcategory, { foreignKey:{name: 'categoryId'} ,allowNull:false });
    subcategory.belongsTo(category, { foreignKey: {name: 'categoryId'} });

    subcategory.hasMany(Product, { foreignKey: {name: 'subcategoryId'}  ,allowNull:false });
    Product.belongsTo(subcategory, { foreignKey: {name: 'subcategoryId'}});

    category.hasMany(Product, { foreignKey:{name: 'categoryId'} ,allowNull:false});
    Product.belongsTo(category, { foreignKey:{name: 'categoryId'} });

    User.hasMany(cart, { foreignKey: {name: 'UserId', allowNull: false } });
    cart.belongsTo(User, { foreignKey: 'UserId' });

    cart.hasMany(items, { foreignKey: {name: 'cartId', allowNull: false } });
    items.belongsTo(cart, { foreignKey: 'cartId' });

    Product.hasMany(items, { foreignKey: {name: 'productId', allowNull: false } });
    items.belongsTo(Product, { foreignKey: 'productId' });

    cart.hasOne(order, { foreignKey: {name: 'cartId', allowNull: false } });
    order.belongsTo(cart, { foreignKey: 'cartId' });

};


export default relation;
