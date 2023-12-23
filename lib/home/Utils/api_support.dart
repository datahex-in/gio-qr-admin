class Apis {
  static const String baseUrl = "https://gio-event-api-dc283.ondigitalocean.app/api/v1";
  static   String getDetails(mobile) => "$baseUrl/registration/getInfo?mobile=$mobile";
  
}