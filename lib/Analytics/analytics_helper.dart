import 'package:firebase_analytics/firebase_analytics.dart';

class MyAnalytics {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // sudah
  Future<void> clikcbutton(_value) async {
    await analytics.logEvent(
      name: "${_value}_click", 
      parameters: {'value': "user klik button ${_value}"}
    );
    print(_value);
  }

  //sudah
  Future<void> userLogin(email)async {
    await analytics.logEvent(
      name: "user login",
      parameters: {'email': email}
    );
  }

  //sudah
  Future<void> userRegister(email)async {
    await analytics.logEvent(
      name: "user Register",
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
  }

  // sudah
  Future<void> userpindahPage(page)async {
    await analytics.logEvent(
      name: "user pindah halaman",
      parameters: {'halaman': "pindah ke ${page}"}
    );
  }


  // sudah
  Future<void> userpencarian(pencarian)async {
    await analytics.logEvent(
      name: "user melakukan pencarian",
      parameters: {'pencarian': "user mencari ${pencarian}"}
    );
  }

  //sudah
  Future<void> usertimeout()async {
    await analytics.setSessionTimeoutDuration(
      Duration(minutes: 1)
    );
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