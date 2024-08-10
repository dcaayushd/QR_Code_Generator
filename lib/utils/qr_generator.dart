class QrGenerator {
  static String getWifiString({
    required String ssid,
    required String password,
    String encryption = 'WPA',
  }) {
    return 'WIFI:S:$ssid;T:$encryption;P:$password;;';
  }
}
