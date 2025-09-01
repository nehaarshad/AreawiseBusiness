class FaqItem {
  final String question;
  final String answer;
  bool isExpanded;

  FaqItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

final List<FaqItem> faqItems = [

  FaqItem(
    question: "Is the app free to use?",
    answer: "Yes, the app is free to download and use for browsing products. Shop owners may have premium features available for enhanced visibility and management tools.",
  ),

  FaqItem(
    question: "How do I register my shop on the app?",
    answer: "Go to 'Business Account' in app, tap 'Add Shop' inside 'My Shop', fill in your shop details including name, address, contact information, and Category. Your shop will be reviewed and activated within 24 hours.",
  ),

  FaqItem(
    question: "Can I manage multiple shops from one account?",
    answer: "Yes, each account can manage multiple shop. If you have multiple locations, you no need to create separate accounts or contact support for multi-location business solutions.",
  ),

  FaqItem(
    question: "How do I add products to my shop?",
    answer: "In your Business Account, tap 'Add Product' inside 'My Product Option', upload clear photos, enter product details including name, description, price, category, and stock quantity. Your product will be live immediately.",
  ),

  FaqItem(
    question: "How many products can I add to my shop?",
    answer: "There's no limit to the number of products you can add. However, ensure all products are accurately described and properly categorized for better visibility.",
  ),

  FaqItem(
    question: "Can I edit or delete my products?",
    answer: "Yes, go to 'My Products' in your Business Account. You can edit product details, update prices, modify stock quantities, or delete products anytime.",
  ),

  FaqItem(
    question: "What does 'Request to Feature Product' mean?",
    answer: "Featured products appear at the top of search results and category pages. Submit a feature request from your product page, and our team will review it.",
  ),

  FaqItem(
    question: "How long does it take for feature requests to be processed?",
    answer: "Feature requests are typically reviewed within 2-3 business days. You'll receive a notification about approval or rejection.",
  ),

  FaqItem(
    question: "Can customers find my shop if I'm not exactly on their route?",
    answer: "Yes, customers can discover your shop through shop searches, and product searches. Having complete shop information helps with discoverability.",
  ),

  FaqItem(
    question: "How do customers contact about products?",
    answer: "Customers can contact you through the in-app messaging system,  or visit your physical location.",
  ),

  FaqItem(
    question: "Is there an in-app payment system?",
    answer: "Currently, payments are handled directly between buyers and sellers. The app facilitates contact and product discovery. Payment methods are arranged between you and your customers.",
  ),

  FaqItem(
    question: "How do I handle product availability?",
    answer: "Always keep your product stock levels updated. Delete products when unavailable, and update quantities regularly to avoid customer disappointment.",
  ),

  FaqItem(
    question: "How do I switch between customer and business accounts?",
    answer: "You can easily switch modes by tap on 'Business Account;. Customer mode for browsing and buying, Business mode for managing your shop and products.",
  ),

  FaqItem(
    question: "Is my personal information safe?",
    answer: "Yes, we use encryption to protect your data. Shop owners' business information is displayed publicly, but personal details remain private",
  ),

  FaqItem(
    question: "What should I do if the app isn't working properly?",
    answer: "Try closing and reopening the app, and check your internet connection. If problems persist, contact our support team with details about the issue.",
  ),

  FaqItem(
    question: "How can I make my shop more successful?",
    answer: "Use high-quality photos, write detailed product descriptions, respond quickly to customer inquiries, keep your inventory updated, and consider featuring popular products for better visibility.",
  ),

  FaqItem(
    question: "What are the best practices for product photography?",
    answer: "Use natural lighting, show products from multiple angles, include size references, ensure images are clear and high-resolution, and showcase products in use when possible.",
  ),
];
