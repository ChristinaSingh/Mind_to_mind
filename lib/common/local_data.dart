class LocalData {
  static String userId = '';
  static String userType = 'Mentee';
  static bool showUserScreen = true;
  static String lat = '51.1657';
  static String lon = '10.4515';
  static String address = '';

  static void setLatLon(String lat, String lon, String address) {
    LocalData.lat = lat;
    LocalData.lon = lon;
    LocalData.address = address;
    print('Successfully set current location lat lon...');
  }

}
