// ignore: camel_case_types


// ignore: camel_case_types
class URL_LOGIC {


  static String api2="https://zad-solutions.com/api-wellbond/"; // server
  // static String api2="http://196.221.151.69:8085/zad-wellbond-backend/"; // server


  static String login = api2 + "auth/sign-in";
  static String refrechToken=api2+"auth/refresh-token";
  // ignore: non_constant_identifier_names
  static String uplodeImage = api2 + "security-user/upload-profile-image?fileName=";
//  static String uplodeImage = api2 + "security-user/upload-profile-image?";
// ignore: non_constant_identifier_names
  static String token_firebase_send=api2+"security-user/set-user-device-token";

  // ignore: non_constant_identifier_names
  static String  change_password=api2+"auth/change-password";
  // ignore: non_constant_identifier_names
  static String   update_profile=api2+"security-user/update";
  // ignore: non_constant_identifier_names
  static String getInfo_dataUser=api2+"security-user/get-logged-in-info-user";

  static String notification=api2+"notification-mobile/get-notification-logged-in-user";
// ignore: non_constant_identifier_names
  static String listItem_Home = api2 + "order-mobile/employee/get-incoming-orders?page=";
  // ignore: non_constant_identifier_names
  static String listItem_Home_serch = api2 + "order-mobile/employee/search-incoming-by-customer-name-or-order-id?searchKey=";
  // ignore: non_constant_identifier_names
  static String find_bu_id_item = api2 + "order-mobile/employee/get-order-by-id?orderId=";
//  static String find_bu_id_item = api2 + "order-mobile/find?id=";

// ignore: non_constant_identifier_names
  static String done_order = api2 + "order-mobile/update-order";
  // ignore: non_constant_identifier_names
  static String rejectFlag_or_cancel_order = api2 + "cancelled-lookup/find-by-reject-flag?rejectFlag=";
// ignore: non_constant_identifier_names
  static String cancel_order = api2 + "order-mobile/employee/cancel-order";
  // ignore: non_constant_identifier_names
  static String reject_order = api2 + "order-mobile/employee/reject-order";
// ignore: non_constant_identifier_names
  static String running_order = api2 + "order-mobile/employee/get-running-orders?page=";
  // ignore: non_constant_identifier_names
  static String running_order_serch = api2 + "order-mobile/employee/search-running-by-customer-name-or-order-id?searchKey=";
  // ignore: non_constant_identifier_names
  static String running_order_serch_sates = api2 + "order-mobile/employee/get-order-by-status?statusId=";

// ignore: non_constant_identifier_names
  static String arseeff_order = api2 + "order-mobile/employee/get-completed-orders?page=";
  // ignore: non_constant_identifier_names
  static String arseeff_order_serch = api2 + "order-mobile/employee/search-completed-customer-name-or-order-id?searchKey=";

// ignore: non_constant_identifier_names
  static String sind_Fillter="${api2}order-mobile/filter-customer-order?orderTotalFrom=10&orderTotalTo=10000&submitDateFrom=2020-08-09&submitDateTo=2020-09-10&page=0&size=15";


}