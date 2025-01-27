import User from "./userModel.js";
import Address from "./addressmodel.js";
import shop from "./shopmodel.js";
import Product from "./productmodel.js";
import category from "./categoryModel.js";
import subcategory from "./subCategoryModel.js";
import image from "./imagesModel.js";

const relation = () => {
    //user relation.......
    User.hasOne(Address, {foreignKey: {  name: 'userId', allowNull: false } });
    Address.belongsTo(User, { foreignKey: 'userId' });

    User.hasMany(shop, { foreignKey: {name: 'userId', allowNull: false } });
    shop.belongsTo(User, { foreignKey: 'userId' });

    User.hasOne(image,{foreignKey:{name:"entityId",scope: {imagetype: 'user'}, allowNull:false}});
    image.belongsTo(User,{foreignKey:{name:"entityId"}});

    User.hasMany(Product, { foreignKey: {name: 'seller', allowNull: false } });
    Product.belongsTo(User, { foreignKey: 'seller' });

    //shop relations.........
    shop.hasMany(Product, { foreignKey: {name: 'shopid', allowNull: false } });
    Product.belongsTo(shop, { foreignKey: 'shopid' });

    shop.hasMany(image,{foreignKey:{name:'entityId',scope: {imagetype: 'shop'},allowNull:false}});
    image.belongsTo(shop,{foreignKey:{name:'entityId'}});

    category.hasMany(shop,{foreignKey:{name:'categoryId',allowNull:false}});
    shop.belongsTo(category,{foreignKey:{name:'categoryId'}});

    //product relations.....
    Product.hasMany(image,{foreignKey:{name:'entityId',scope: {imagetype: 'product'},allowNull:false}});
    image.belongsTo(Product,{foreignKey:{name:'entityId'}});

    
    category.hasMany(subcategory, { foreignKey:{name: 'categoryId'} ,allowNull:false });
    subcategory.belongsTo(category, { foreignKey: {name: 'categoryId'} });

    subcategory.hasMany(Product, { foreignKey: {name: 'subcategoryId'}  ,allowNull:false });
    Product.belongsTo(subcategory, { foreignKey: {name: 'subcategoryId'}});

    category.hasMany(Product, { foreignKey:{name: 'categoryId'} ,allowNull:false});
    Product.belongsTo(category, { foreignKey:{name: 'categoryId'} });

};


export default relation;
