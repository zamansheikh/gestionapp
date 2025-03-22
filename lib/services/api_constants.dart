class ApiConstants {
  static const String baseUrl = "http://46.202.132.176:5002/api/v1";
  static const String imageBaseUrl = "http://46.202.132.176:5002/";
  static const String socketUrl = "http://46.202.132.176:5002/";

  static const String signInEndPoint = "/auth/login";
  static String getPropertyById(String id) => "/property/owner/$id";
  static String reservationProperty(
          String id, String startDate, String endDate) =>
      "/property/reservation/room/$id?startDate=$startDate&endDate=$endDate";
  static String reservationPropertyLog(
          String id, String startDate, String endDate) =>
      "/property/reservation/room/log/$id?startDate=$startDate&endDate=$endDate";
  static const String updateProfileEndPoint = "/user/update-profile";
  static const String getUserProfileEndPoint = "/user/profile";
  static const String getAllUser = "/user/get-all-users";
  static const String getAllRooms = "/property/zak-rooms";
  static const String createClientEndPoint = "/user";
  static const String propertyEndPoint = "/property";
  static const String changePasswordEndPoint = "/auth/change-password";
  static const String forgetPasswordEndPoint = "/auth/forgot-password";
  static const String verifyOtpEndPoint = "/auth/verify-email";
  static const String resetPassEndPoint = "/auth/reset-password";
  static const String deleteUser = "/user/delete-user/";
  static const String deleteProperty = "/property/remove-property/";
}
