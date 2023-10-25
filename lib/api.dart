// var webApi = {'domain': 'https://api.iteeha.co'}; //PROD
// var webApi = {'domain': 'http://43.205.30.95:3000'}; //DEV PROD
// var webApi = {'domain': 'http://192.168.1.33:3000'}; // Atharv Home
// var webApi = {'domain': 'http://192.168.0.5:3000'}; // Atharv Work
// var webApi = {'domain': 'http://172.20.10.5:3000'}; // Atharv Hotspot
// var webApi = {'domain': 'http://192.168.227.72:3000'}; // Salman
var webApi = {'domain': 'http://192.168.1.4:3000'}; // Darshan wifi
// var webApi = {'domain': 'http://192.168.95.161:3000'}; // Darshan hotspot2
// var webApi = {'domain': 'http://192.168.234.161:3000'}; // Darshan hotspot

var endPoint = {
  // App Config
  'searchLocationFromGoogle': '/appConfig/searchLocationFromGoogle',
  'fetchCommonAppConfig': '/appConfig/fetchCommonAppConfig',
  'getAppConfigs': '/appConfig/getAppConfigs',

  // Banner
  'fetchBanners': '/banner/fetchBanners',

  // Authentication
  'sendOTPtoUser': '/auth/send-otp',
  'verifyOTPofUser': '/auth/verify-otp',
  'resendOTPtoUser': '/auth/resend-otp',
  'login': '/user/login',
  'register': '/user/register',
  'editProfile': '/user/editProfile',
  'deleteFCMToken': '/user/deleteFCMToken',
  'updateAddress': '/user/updateAddress',
  'deleteAccount': '/user/deleteAccount',
  'refreshUser': '/user/refreshUser',

  // Notifications
  'fetchNotifications': '/notification/fetchNotifications',
  'updateViewState': '/notification/updateViewState',

  // Cafe
  'fetchCafe': '/cafe/fetchCafe',
  'fetchSingleCafeById': '/cafe/fetchSingleCafeById',

  // Like Unlike
  'likeUnlike': '/like/likeUnlike',

  // LoyaltyLevel
  'fetchLoyaltyLevels': '/loyalty/fetchLoyaltyLevels',

  // Offers
  'fetchOffers': '/offers/fetchOffers',

  // Transaction
  'fetchTransactions': '/transaction/fetchTransactions',
  'walletRecharge': '/transaction/walletRecharge',

  // More Screen
  'fetchFaqs': '/faq/fetchFaqs',
  'fetchFaqTopics': '/faqTopic/fetchFaqTopics',
};
