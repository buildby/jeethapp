// var webApi = {'domain': 'https://api.iteeha.co'}; //PROD
// var webApi = {'domain': 'http://43.205.30.95:4000'}; //DEV PROD
// var webApi = {'domain': 'http://192.168.1.33:4000'}; // Atharv Home
// var webApi = {'domain': 'http://192.168.0.5:4000'}; // Atharv Work
// var webApi = {'domain': 'http://172.20.10.5:4000'}; // Atharv Hotspot
// var webApi = {'domain': 'http://192.168.227.72:4000'}; // Salman
var webApi = {'domain': 'http://192.168.1.4:3000'}; // Darshan wifi
// var webApi = {'domain': 'http://192.168.95.161:4000'}; // Darshan hotspot2
// var webApi = {'domain': 'http://192.168.234.161:3000'}; // Darshan hotspot

var endPoint = {
  // App Config
  'searchLocationFromGoogle': '/api/appConfig/searchLocationFromGoogle',
  'fetchCommonAppConfig': '/api/appConfig/fetchCommonAppConfig',
  'getAppConfigs': '/api/appConfig/getAppConfigs',

  // Banner
  'fetchBanners': '/api/banner/fetchBanners',

  // Authentication
  'sendOTPtoUser': '/api/auth/sendOTPtoUser',
  'verifyOTPofUser': '/api/auth/verifyOTPofUser',
  'resendOTPtoUser': '/api/auth/resendOTPtoUser',
  'login': '/api/user/login',
  'register': '/api/user/register',
  'editProfile': '/api/user/editProfile',
  'deleteFCMToken': '/api/user/deleteFCMToken',
  'updateAddress': '/api/user/updateAddress',
  'deleteAccount': '/api/user/deleteAccount',
  'refreshUser': '/api/user/refreshUser',

  // Notifications
  'fetchNotifications': '/api/notification/fetchNotifications',
  'updateViewState': '/api/notification/updateViewState',

  // Cafe
  'fetchCafe': '/api/cafe/fetchCafe',
  'fetchSingleCafeById': '/api/cafe/fetchSingleCafeById',

  // Like Unlike
  'likeUnlike': '/api/like/likeUnlike',

  // LoyaltyLevel
  'fetchLoyaltyLevels': '/api/loyalty/fetchLoyaltyLevels',

  // Offers
  'fetchOffers': '/api/offers/fetchOffers',

  // Transaction
  'fetchTransactions': '/api/transaction/fetchTransactions',
  'walletRecharge': '/api/transaction/walletRecharge',

  // More Screen
  'fetchFaqs': '/api/faq/fetchFaqs',
  'fetchFaqTopics': '/api/faqTopic/fetchFaqTopics',
};
