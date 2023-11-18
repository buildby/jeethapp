// var webApi = {'domain': 'https://api.jeeth.co.in'}; //PROD
// var webApi = {'domain': 'http://43.205.30.95:3000'}; //DEV PROD
// var webApi = {'domain': 'http://192.168.1.35:3000'}; // Atharv Home
// var webApi = {'domain': 'http://172.20.10.5:3000'}; // Atharv Hotspot
// var webApi = {'domain': 'http://192.168.56.1:3000'}; // Darshan wifi
var webApi = {'domain': 'http://192.168.27.161:3000'}; // Darshan hotspot

var endPoint = {
  // App Config
  'searchLocationFromGoogle': '/appConfig/searchLocationFromGoogle',
  'fetchCommonAppConfig': '/appConfig/fetchCommonAppConfig',
  'fetchVehicleConfigs': '/appConfig/fetchVehicleConfigs',
  'createVehicleConfigs': '/appConfig/createVehicleConfigs',

  // Banner
  'fetchBanners': '/banner/fetchBanners',

  // Authentication
  'sendOTPtoUser': '/auth/send-otp',
  'verifyOTPofUser': '/auth/verify-otp',
  'resendOTPtoUser': '/auth/resend-otp',
  'login': '/user/login',
  'driverAutoLogin': '/auth/driverAutoLogin',
  'register': '/user/register',
  'deleteFCMToken': '/user/deleteFCMToken',
  'updateAddress': '/user/updateAddress',
  'deleteAccount': '/user/deleteAccount',
  'refreshUser': '/user/refreshUser',

  //Documents
  'getAwsSignedUrl': '/aws/getSignedUrl',
  'updateDriverDocument': '/document/updateDriverDocument',
  'getDriverDocuments': '/document/getDriverDocuments',

  //Driver
  'editDriverProfile': '/driver/editDriverProfile',
  'refreshUserEarnings': '/driver/refreshUserEarnings',

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

  // Market place
  'fetchAllCampaignsApp': '/campaign/fetchAllCampaignsApp',

  // My Application
  'createMyApplication': '/driverApplication',
  'fetchMyApplication': '/driverApplication',
  'isAlreadyAppliedApplication': '/driverApplication',
};
