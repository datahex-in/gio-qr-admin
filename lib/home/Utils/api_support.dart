class Apis {
  static const String baseUrl =
      "https://gio-event-api-dc283.ondigitalocean.app/api/v1";
  static String getDetails(mobile) =>
      "https://gio-event-api-dc283.ondigitalocean.app/api/v1/registration/getInfo?mobile=$mobile";
}
