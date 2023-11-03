import 'dart:io';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jeeth_app/authModule/models/driver_model.dart';
import 'package:jeeth_app/common_functions.dart';
import 'package:localstorage/localstorage.dart';

import '../../http_helper.dart';
import '../models/user_model.dart';
import '../../api.dart';

class AuthProvider with ChangeNotifier {
  final LocalStorage storage = LocalStorage('jeeth_app');
  List availableLanguages = [];

  String razorpayId = 'rzp_test_T4eGUVSdlEPgNm';
  String helpAndSuppWhatsApp = '7666136015';

  Map get selectedLanguage => {
// Auth Screen
        "onRide": "We're\ngoing\non a ride.",
        "areYouIn": "Are you in?",
        "getStarted": "Get started",
        "somethingWentWrong": "Something Went Wrong",
        "enterYourMobileNumber": "Enter your mobile number",
        "message": "message",
        "phoneNumberToVerify":
            "We need your phone number to verify your identity",
        "get": "GET",
        "set": "SET",
        "go": "GO",
        "getOtp": "Get OTP",
        "inCompleteProfBtmStSubtitle":
            "Fill in all your details and upload\nrequired documents to get your\nprofile approved.",
        "phoneVerification": "Phone verification",
        "enterOtpHere": "Enter your OTP code here",
        "proceed": "Proceed",
        "marketplace": "Marketplace",
        "vendor": "Vendor : ",
        "incompleteProfile": "Incomplete Profile",
        "profile/Documents": "Profile/Documents",
        "driverDetails": "Driver Details",
        "swipeForVehicleDetails": "Swipe for Vehicle Details",
        "swipeForDriverDetails": "Swipe For Driver Details",
        "driverDocuments": "Driver Documents",
        "vehicleDetails": "Vehicle Details",
        "vehicleDocuments": "Vehicle Documents",
        "vehicle/OwnerDetails": "Vehicle/Owner Details",
        "ownerDetails": "Owner Details",
        "ownerDocuments": "Owner Documents",
        "save": "Save",
        "profileIncomplete": "Your Profile is incomplete.",
        "next": "Next",
        "enterVehicleNumber": "Enter Vehicle Number",
        "selectVehicleModel": "Select Vehicle Model",
        "enterOwnerName": "Enter Owner Name",
        "enterownerAddress": "Enter Owner Address",
        "enterOwnerMobileNumber": "Enter Owner Mobile Number",
        "selectModel": "Select Model",
        "selectType": "Select Type",
        "selectMake": "Select Make",
        "selectYear": "Select Year",
        "selectVehicleYear": "Select Vehicle Year",
        "selectVehicleType": "Select Vehicle Type",
        "selectVehicleMake": "Select Vehicle Make",
        "bankAccountDetails": "Bank Account Details",
        "selectGender": "Select Gender",
        "enterName": "Enter Name",
        "yes": "Yes",
        "no": "No",
        "name": "Name",
        "email": "Email",
        "dob": "Date of birth",
        "fullAddress": "Full address",
        "gender": "Gender",
        "bankName": "Bank name",
        "selectBank": "Select Bank",
        "accNumber": "Account number",
        "confimrAccNumber": "Confirm account number",
        "ifscCode": "IFSC code",
        "enterVehiclePhoto": "Please enter vehicle photo",
        "enterDriverPhoto": "Please enter driver photo",
        "enterFields": "Please enter details and documents",
        "gotIt": "Got it",

// Home Screen
        "chooseYourClient": "Choose your client",
        "explore": "Explore",
        "work": "Work",
        "earnings": "Earnings",
        "reports": "Reports",
        "help": "Help",

// Explore Deal Screen
        "exploreDeal": "Explore Deal",
        "company": "Company",
        "loginSlots": "Login Slots",
        "logoutSlots": "Logout Slots",
        "applyNow": "Apply Now",
        "profileWillSubmitted": "Your Profile will be submitted",
        "profileHasSubmitted": "Your Profile has been submitted",
        "agreementSubtitle":
            "Your Profile data will be shared with the vendor along with all the attached documents and video-kyc Report for Induction Approval.",
        "iAgree": "I Agree",
        "done": "Done",

// Earnings Screen
        "accruedEarnings": "Accrued Earnings",
        "currentMonthEarnings": "Current month earnings",
        "eligibleToWithdraw": "Eligible to withdraw ",
        "withdrawAmount": "Withdraw amount",
        "earningsLastWeek": "Your earnings in the last 7 days",

// Navigation Drawer
        "wallet": "Wallet",
        "myProfile": "My Profile",
        "myApplications": "My Applications",
        "notifications": "Notifications",
        "referAFriend": "Refer a friend",
        "appSettings": "App Settings",
        "logout": "Log Out",
        "logoutMessage": "Are you sure you want to Log Out?",
        "wantToLogout": "Are you sure you want to logout?",
        "settings": "Settings",

// Reports Screen
        "yourWeeklyPerformance": "Your Weekly Performance",
        "MISReport": "MIS Report",
        "performanceReport": "Performance Report",
        "earningsReport": "Earnings Report",
        "maintainOta/Otd":
            "Maintain your OTA/OTD\ngreater than 95% to unlock\nbest deals for you",

// Help Screen
        "contactVendorHelpline": "Contact Vendor Helpline",
        "tapToCall": "Tap to Call",
        "reportAnIssue": "Report an issue",
        "AccountProfile": "Account and Profile",
        "paymentsAndWithdrawals": "Payments and Withdrawals",
        "callAndReport":
            "Please call and report the\ninstance to your coordinator\nin case of emergency",

// Settings Screen
        "active": "Active",
        "security": "Security",
        "language": "Language",
        "permissions": "Permissions",

// Refer a  friend Screen
        "referAndEarn": "Refer and Earn",
        "shareAppContent":
            "Invite your friends to download the JEETH mobile app and earn rewards for every referral.",
        "shareTheDownloadLink": "Share the download link",

// My Applications Screen
        "awaitingApproval": "Awaiting approval",
        "denied": "Denied",
        "approved": "Approved, Visit site location.",
        "inductionPending": "INDUCTION PENDING!",
        "decisionPending": "Decision Pending!",
        "applicationDenied": "Application Denied!",
        "pendingPara":
            "Your application has been\nreceived by the vendor, and it is\nunder verification process.\nPlease check back later.",
        "backHome": "Back Home",
        "rejectedPara":
            "Your application has been\ncarefully reviewed by the vendor\nbut unfortunately it is rejected for\nthe following reasons.",
        "incorrectDocuments": "Incorrect Documents, ",
        "kindlyReupload": "Kindly re-upload the pending documents and reapply.",
        "takeMeToProfile": "Take me to Profile",
        "fieldOfficer": "Field Officer",
        "navigateToLocation": "Navigate to location",
      };

  late User user;

  String androidVersion = '0';
  String iOSVersion = '0';
  Map? deleteFeature;

  List<String> makes = [];
  List<Map<String, dynamic>> models = [];

  // setGuestUser() {
  //   user = User(isGuest: true, id: '');
  // }

  // void updatePermission({
  //   required String permissionType,
  //   required bool newValue,
  // }) {
  //   if (permissionType == 'location') {
  //     user.isLocationAllowed = newValue;
  //   } else {
  //     user.isNotificationAllowed = newValue;
  //   }
  //   notifyListeners();
  // }

  refreshUser() async {
    final String url = '${webApi['domain']}${endPoint['refreshUser']}';
    try {
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
        accessToken: user.accessToken,
      );

      if (response['success']) {
        user =
            User.jsonToUser(response['result'], accessToken: user.accessToken);

        notifyListeners();
      }

      notifyListeners();
      return response;
    } catch (e) {
      return {'success': false, 'message': 'failedToRefresh'};
    }
  }

  // fetchMyLocation() async {
  //   late LatLng coord;
  //   final location = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high)
  //       .catchError((e) {
  //     print(e);
  //   });
  //   coord = LatLng(location.latitude, location.longitude);
  //   user.coordinates = coord;
  //   notifyListeners();
  //   return true;
  // }

  sendOTPtoUser(String mobileNo, {bool business = false}) async {
    final url = '${webApi['domain']}${endPoint['sendOTPtoUser']}';
    Map body = {
      'phoneNumber': mobileNo,
    };
    try {
      final response = await RemoteServices.httpRequest(
          method: 'POST', url: url, body: body);

      return response;
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  createVehicleConfigs() async {
    final url = '${webApi['domain']}${endPoint['createVehicleConfigs']}';
    Map body = {
      // 'value': ['Toyota', 'Maruti Suzuki', 'Kia', 'Honda', 'Hyundai'],
      "type": 'Vehicle Models',
      'value': [
        {
          'make': 'Toyota',
          'type': 'Sedan',
          'value': 'Corolla',
        },
        {
          'make': 'Toyota',
          'type': 'SUV',
          'value': 'Innova',
        },
        {
          'make': 'Toyota',
          'type': 'SUV',
          'value': 'Fortuner',
        },
        {
          'make': 'Maruti Suzuki',
          'type': 'Sedan',
          'value': 'Swift',
        },
        {
          'make': 'Maruti Suzuki',
          'type': 'Mini',
          'value': 'WagonR',
        },
        {
          'make': 'Kia',
          'type': 'SUV',
          'value': 'Seltos',
        },
        {
          'make': 'Kia',
          'type': 'Maybach',
          'value': 'Sonet',
        },
        {
          'make': 'Honda',
          'type': 'Sedan',
          'value': 'Civic',
        },
        {
          'make': 'Honda',
          'type': 'Sedan',
          'value': 'City',
        },
        {
          'make': 'Hyundai',
          'type': 'Sedan',
          'value': 'Elantra',
        },
        {
          'make': 'Hyundai',
          'type': 'SUV',
          'value': 'Creta',
        },
      ],
    };
    try {
      final response =
          await RemoteServices.httpRequest(method: 'PUT', url: url, body: body);

      return response['result']['type'];
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  fetchVehicleConfigs() async {
    final url = '${webApi['domain']}${endPoint['fetchVehicleConfigs']}';

    try {
      final response = await RemoteServices.httpRequest(
        method: 'GET',
        url: url,
      );
      if (response['result'] == 'success') {
        makes = List.from(response['data']['makes']);
        models = List.from(response['data']['models']);
      }
      return response;
    } catch (error) {
      return {'result': 'failure', 'data': null};
    }
  }

  resendOTPtoUser(String mobileNo, String type) async {
    final url = '${webApi['domain']}${endPoint['resendOTPtoUser']}';
    Map body = {
      'mobileNo': mobileNo,
      "type": type,
    };
    try {
      final response = await RemoteServices.httpRequest(
          method: 'POST', url: url, body: body);

      return response['result']['type'];
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  verifyOTPofUser(String mobileNo, String otp) async {
    final url = '${webApi['domain']}${endPoint['verifyOTPofUser']}';
    Map body = {
      'phoneNumber': mobileNo,
      "otp": otp,
    };
    try {
      final response = await RemoteServices.httpRequest(
          method: 'POST', url: url, body: body);

      if (response['result'] == 'success' && response['data']['user'] != null) {
        response['data']['user']['driver'] = response['data']['driver'];
        user = User.jsonToUser(response['data']['user'],
            accessToken: response['token']);

        await storage.ready;
        await storage.setItem(
            'accessToken',
            json.encode({
              "token": user.accessToken,
              "phone": user.phone,
            }));

        // user = User.jsonToUser(response['data']['driver'],
        //     accessToken: response['token']);
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'result': 'Failure', 'data': null};
    }
  }

// get app config from DBDB
  getAppConfig(List<String> types) async {
    final url = '${webApi['domain']}${endPoint['getAppConfigs']}';

    try {
      final response = await RemoteServices.httpRequest(
          method: 'POST', url: url, body: {"types": types});
      if (response['success']) {
        (response['result'] as List).forEach((config) {
          if (config['type'].contains("user_availableLanguages")) {
            availableLanguages = config['value'];
          } else if (config['type'].contains("user-")) {
            // selectedLanguage = config['value'];
          } else if (config['type'] == 'delete_feature') {
            deleteFeature = Platform.isAndroid
                ? config['value']['android']
                : config['value']['iOS'];
          } else if (config['type'] == 'Razorpay') {
            razorpayId = config['value'];
          } else if (config['type'] == 'helpAndSuppWhatsApp') {
            helpAndSuppWhatsApp = config['value'];
          }
        });
      }
      return response;
//
    } catch (error) {
      return {'success': false, 'message': 'Failed to get data'};
    }
  }

  setLanguageInStorage(String language) async {
    await storage.ready;
    storage.setItem('language', json.encode({"language": language}));
    notifyListeners();
  }

  Future login({required String query}) async {
    // String? fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null && fcmToken != '') {
    //   query += '&fcmToken=$fcmToken';
    // }

    try {
      final url = '${webApi['domain']}${endPoint['login']}$query';
      final response =
          await RemoteServices.httpRequest(method: 'GET', url: url);

      if (response['success'] && response['login']) {
        user = User.jsonToUser(
          response['result'],
          accessToken: response['accessToken'],
        );

        // user.fcmToken = fcmToken ?? '';

        await storage.ready;
        await storage.setItem(
            'accessToken',
            json.encode({
              "token": user.accessToken,
              "phone": user.phone,
            }));
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'login': false};
    }
  }

  Future register(
      {required Map<String, String> body,
      required Map<String, String> files}) async {
    // String? fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null && fcmToken != '') {
    //   body['fcmToken'] = fcmToken;
    // }

    try {
      final url = '${webApi['domain']}${endPoint['register']}';
      final response = await RemoteServices.formDataRequest(
        method: 'POST',
        url: url,
        body: body,
        files: files,
      );

      if (response['success']) {
        user = User.jsonToUser(
          response['result'],
          accessToken: response['accessToken'],
        );

        // user.fcmToken = fcmToken ?? '';

        await storage.ready;
        await storage.setItem(
            'accessToken',
            json.encode({
              "token": user.accessToken,
              "phone": user.phone,
            }));
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedToRegister'};
    }
  }

  Future editDriverProfile({
    required String id,
    required Map body,
  }) async {
    try {
      final url = '${webApi['domain']}${endPoint['editDriverProfile']}/$id';
      final response = await RemoteServices.httpRequest(
        method: 'PUT',
        url: url,
        body: body,
        accessToken: user.accessToken,
      );
      if (response['result'] == 'success') {
        user.driver = Driver.jsonToDriver(response['data']);
      }

      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedToSave'};
    }
  }

  Future updateDocument({
    required String id,
    required String driverId,
    required String fileName,
    required String filePath,
  }) async {
    //  String? fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null && fcmToken != '') {
    //   query += '&fcmToken=$fcmToken';
    // }

    try {
      final url = '${webApi['domain']}${endPoint['document']}/$id/$driverId';
      final response =
          await RemoteServices.httpRequest(method: 'PUT', url: url);

      if (response['result'] == 'success') {
        final s3Response = await http.put(
          Uri.parse(response['data']['signedUrl']),
          body: File(filePath).readAsBytesSync(),
        );

        if (s3Response != null) {
          showSnackbar(s3Response.toString());
        }
      }
      notifyListeners();
      return response;
    } catch (error) {
      return {'success': false, 'message': 'failedToGetSignedUrl'};
    }
  }

  Future getAwsSignedUrl({
    required String fileName,
    required String filePath,
    // required Map<String, String> files,
    // required Map<String, String> body,
  }) async {
    //  String? fcmToken = await FirebaseMessaging.instance.getToken();
    // if (fcmToken != null && fcmToken != '') {
    //   query += '&fcmToken=$fcmToken';
    // }

    try {
      final url = '${webApi['domain']}${endPoint['getAwsSignedUrl']}/$fileName';
      final response =
          await RemoteServices.httpRequest(method: 'GET', url: url);

      if (response['result'] == 'success') {
        final s3Response = await http.put(
          Uri.parse(response['data']['signedUrl']),
          body: File(filePath).readAsBytesSync(),
        );

        // if (s3Response != null) {
        //   showSnackbar(s3Response.toString());
        // }
      }

      return response;
    } catch (error) {
      return {'result': 'failure', 'message': 'failedToGetSignedUrl'};
    }
  }

  // Future getDriverDocuments({
  //   required String fileName,
  //   required String filePath,
  //   required String type,
  // }) async {
  //   //  String? fcmToken = await FirebaseMessaging.instance.getToken();
  //   // if (fcmToken != null && fcmToken != '') {
  //   //   query += '&fcmToken=$fcmToken';
  //   // }

  //   try {
  //     final url = '${webApi['domain']}${endPoint['getAwsSignedUrl']}/$fileName';
  //     final response =
  //         await RemoteServices.httpRequest(method: 'GET', url: url);

  //     if (response['result'] == 'success') {
  //       final s3Response = await http.put(
  //         Uri.parse(response['data']['signedUrl']),
  //         body: File(filePath).readAsBytesSync(),
  //       );

  //       if (s3Response != null) {
  //         showSnackbar(s3Response.toString());
  //       }
  //     }
  //     notifyListeners();
  //     return response;
  //   } catch (error) {
  //     return {'success': false, 'message': 'failedToGetSignedUrl'};
  //   }
  // }

  logout() async {
    // user = null;
    // await deleteFCMToken();
    await storage.clear();
    notifyListeners();
    return true;
  }

  deleteFCMToken() async {
    Map<String, String> body = {'fcmToken': user.fcmToken};

    final String url = '${webApi['domain']}${endPoint['deleteFCMToken']}';
    try {
      final response = await RemoteServices.httpRequest(
        method: 'PUT',
        url: url,
        body: body,
        accessToken: user.accessToken,
      );

      if (!response['success']) {
      } else {
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  fetchPolicy(String type) async {
    final url = '${webApi['domain']}${endPoint['getAppConfigs']}';
    try {
      final response =
          await RemoteServices.httpRequest(method: 'POST', url: url, body: {
        "types": [type]
      });
      if (response['success'] && response['result'] != null) {
        return response['result'][0];
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  deleteAccount() async {
    final String url = '${webApi['domain']}${endPoint['deleteAccount']}';
    try {
      final response = await RemoteServices.httpRequest(
        method: 'PUT',
        url: url,
        accessToken: user.accessToken,
      );

      if (!response['success']) {
      } else {}

      notifyListeners();
      return response;
    } catch (e) {
      return {'success': false, 'message': 'deleteAccountFail'};
    }
  }
}
