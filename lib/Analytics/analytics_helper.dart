import 'package:firebase_analytics/firebase_analytics.dart';

class MyAnalytics {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // sudah
  Future<void> clikcbutton(_value) async {
    await analytics.logEvent(
      name: "${_value}_click", 
      parameters: {'value': "user_klik_button_${_value}"}
    );
    print(_value);
  }

  //sudah
  Future<void> userLogin(email)async {
    await analytics.logEvent(
      name: "user_login",
      parameters: {'email': email}
    );
  }

  //sudah
  Future<void> userRegister(email)async {
    await analytics.logEvent(
      name: "user_Register",
      parameters: {'email': email}
    );
  }

  // sudah
  Future<void> userlogout() async {
    await analytics.logEvent(
      name: 'user_logout',
    );
  }

  // sudah
  Future<void> resetData() async {
    await analytics.resetAnalyticsData();
    print("Analytics data di-reset.");
  }

  // sudah
  Future<void> userpindahPage(page)async {
    await analytics.logEvent(
      name: "user_pindah_halaman",
      parameters: {'halaman': "pindah_ke_${page}"}
    );
  }


  // sudah
  Future<void> userpencarian(pencarian)async {
    await analytics.logEvent(
      name: "user_melakukan_pencarian_${pencarian}",
      parameters: {'pencarian': "user_mencari_${pencarian}"}
    );
  }

  //sudah
  Future<void> usertimeout()async {
    await analytics.setSessionTimeoutDuration(
      Duration(minutes: 1)
    );
    print("Session timeout diatur ke 1 menit.");
  }

  // sudah
  Future<void> userId(id) async {
    await analytics.setUserId(id: id);
  }

  // sudah
  Future<void> userpoperty(email) async {
    await analytics.setUserProperty(
      name: 'email', value: email 
    );
  }
}