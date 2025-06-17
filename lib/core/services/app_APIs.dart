class AppApis {
  static var baseurl = "http://192.168.133.179:5000/api";
  static var socketURL = "http://192.168.161.179:5000";
  //AUTH URLS
  static var loginEndPoints = "$baseurl/login";
  static var signUpEndPoints = "$baseurl/signup";
  static var logoutEndPoints = "$baseurl/logout";
  static var forgetPasswordEndPoints = "$baseurl/forgetpassword";


  //USER PROFILE URLS
  static var getAllUserEndPoints = "$baseurl/getallusers";
  static var SearchUsersByRoleEndPoints = "$baseurl/getallusersbyrole/:role";
  static var SearchUserBynameEndPoints = "$baseurl/getuserbyname/:username";
  static var SearchUserByIdEndPoints = "$baseurl/getuserbyid/:id";
  static var AddUserEndPoints = "$baseurl/adduser";
  static var UpdateUserEndPoints = "$baseurl/updateuser/:id";
  static var DeleteUserEndPoints = "$baseurl/deleteuser/:id";

  //Address URLS
  static var AddUserAddressEndPoints = "$baseurl/addAddress/:id";
  static var GetUserAddressEndPoints = "$baseurl/getAddress/:id";
  static var UpdateUserAddressEndPoints = "$baseurl/updateAddress/:id";
  static var DeleteUserAddressEndPoints = "$baseurl/deleteAddress/:id";

  //Seller Shop Urls
  static var GetAllShopEndPoints = "$baseurl/getallshops";
  static var GetShopByNameEndPoints = "$baseurl/getShopByName/:name";
  static var AddUserShopEndPoints = "$baseurl/addshop/:id";
  static var GetUserShopEndPoints = "$baseurl/getusershop/:id";
  static var FindShopEndPoints = "$baseurl/getshopById/:id";
  static var UpdateUserShopEndPoints = "$baseurl/updateshop/:id";
  static var DeleteUserShopEndPoints = "$baseurl/deleteusershop/:id";
  static var DeleteShopEndPoints = "$baseurl/deleteshopbyid/:id";


  //Category URLs
  static var getCategoriesEndPoints = "$baseurl/getCategories";
  static var getAllsubcategoriesEndPoints = "$baseurl/getallsubcategories";
  static var getSubcategoriesOfCategoryEndPoints = "$baseurl/getsubcategoriesofcategory/:categories";

  //Reviews URLs
  static var getReviewEndPoints = "$baseurl/getReviews/:id";
  static var AddReviewEndPoints = "$baseurl/addReview/:id";
  static var UpdateReviewEndPoints = "$baseurl/updateReview/:id";
  static var DeleteReviewEndPoints = "$baseurl/deleteReview/:id";

  //PRODUCTS URLS  (Seller Perform Operation on their Products + All Products Home Page URL)

  static var getNewArrivalDaysEndPoints = "$baseurl/getproductArrivalDays";
  static var setNewArrivalDaysEndPoints = "$baseurl/updateproductArrivalDays";
  static var AddProductEndPoints = "$baseurl/addproduct/:id";
  static var GetProductsEndPoints = "$baseurl/getallproducts/:Category";
  static var GetProductByIDEndPoints = "$baseurl/getproducts/:id";
  static var GetUserProductsEndPoints = "$baseurl/getuserproducts/:id";
  static var GetShopProductsEndPoints = "$baseurl/getshopproducts/:id";
  static var GetProductByCategoryEndPoints = "$baseurl/getProductByCategory";
  static var getProductByNameEndPoints = "$baseurl/getProductByName/:name";
  static var getNewArrivalProductsEndPoints = "$baseurl/getNewArrivalproducts/:Category";
  static var UpdateProductEndPoints = "$baseurl/updateproduct/:id";
  static var DeleteProductEndPoints = "$baseurl/deleteproduct/:id";
  static var addCategoryEndPoints = "$baseurl/addcategory";
  static var addSubcategoryEndPoints = "$baseurl/addsubcategory";
  static var deleteCategoryEndPoints = "$baseurl/deletecategory/:id";
  static var deleteSubcategoryEndPoints = "$baseurl/deletesubcategory/:id";

  //CART and ORDER URLS
  static var getUserCartEndPoints = "$baseurl/getCart/:id";
  static var addToCartEndPoints = "$baseurl/addToCart/:id";
  static var updateCartItemEndPoints = "$baseurl/updateCartItem/:id";
  static var updateCartEndPoints = "$baseurl/updateCart/:id";
  static var deleteCartItemEndPoints = "$baseurl/removeCartItem/:id";
  static var updateOrderAttributesEndPoints = "$baseurl/updateDeliveryOrderAttributes";
  static var getOrderAttributesEndPoints = "$baseurl/getDeliveryOrderAttributes";
  static var viewCheckOutEndPoints = "$baseurl/ViewCheckout/:id";
  static var placeOrderEndPoints = "$baseurl/PlaceOrder";
  static var deleteCartofUserEndPoints = "$baseurl/deleteCart/:id";


  //WishList APIS
  static var GetWishListofUserEndPoints = "$baseurl/GetWishList/:id";
  static var AddToWishListEndPoints = "$baseurl/AddToWishList/:id";
  static var RemoveFromWishListEndPoints = "$baseurl/RemoveFromWishList/:id";

  //ADs APIS
  static var getAllAdsEndPoints = "$baseurl/getAllAds";
  static var createAdEndPoints = "$baseurl/createAd/:id";
  static var getUserAdsEndPoints = "$baseurl/getUserAds/:id";
  static var deleteAdEndPoints = "$baseurl/deleteAd/:id";

  //FeatureProduct APIS
  static var getAllFeaturedProductsEndPoints = "$baseurl/getAllFeaturedProducts/:Category";
  static var getAllRequestedFeaturedProductsEndPoints = "$baseurl/getAllRequestedFeaturedProducts";
  static var createProductFeaturedEndPoints = "$baseurl/createProductFeatured/:id";
  static var getUserFeaturedProductsEndPoints = "$baseurl/getUserFeaturedProducts/:id";
  static var updateFeaturedProductsEndPoints = "$baseurl/updateFeaturedProducts/:id";
  static var deleteFeaturedProductsEndPoints = "$baseurl/deleteFeaturedProducts/:id";

  //ordersAPIS
  static var getSellerOrderRequestsEndPoints = "$baseurl/seller/:id";
  static var getCustomersOrdersEndPoints = "$baseurl/customer/:id";
  static var updateSellerOrderRequestsStatusEndPoints = "$baseurl/:id";

  //chatApis
  static var getChatsAsSellerEndPoints = "$baseurl/getChatsAsSeller/:id";
  static var getChatsAsBuyerEndPoints = "$baseurl/getChatsAsBuyer/:id";
  static var createChatEndPoints = "$baseurl/createChat/:id";
  static var getChatMessagesEndPoints = "$baseurl/getChatMessages/:id";
  static var deleteChatEndPoints = "$baseurl/deleteChat/:id";


  //Filter Operations (shop -> {name,category}  , products ->{category,name,subcategory,price)
  static var SearchShopByNameEndPoints = "$baseurl/getshopByName/:shopname";
  static var SearchShopByCategoryEndPoints = "$baseurl/getshopByCategory/:category";
}
