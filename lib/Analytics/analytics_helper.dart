import 'package:firebase_analytics/firebase_analytics.dart';

class MyAnalytics {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  DateTime? _screenStartTime;
  String? _currentScreenName;

  // sudah
  Future<void> clikcbutton(_value) async {
    await analytics.logEvent(
      name: "${_value}_click",
      parameters: {'value': "user klik button ${_value}"},
    );
    print(_value);
  }

  //sudah
  Future<void> userLogin(email) async {
    await analytics.logEvent(name: "user login", parameters: {'email': email});
  }

  //sudah
  Future<void> userRegister(email) async {
    await analytics.logEvent(
      name: "user Register",
      parameters: {'email': email},
    );
  }

  // sudah
  Future<void> userlogout() async {
    await analytics.logEvent(name: 'user_logout');
  }

  // sudah
  Future<void> resetData() async {
    await analytics.resetAnalyticsData();
  }

  // sudah
  Future<void> userpindahPage(page) async {
    await analytics.logEvent(
      name: "user pindah halaman",
      parameters: {'halaman': "pindah ke ${page}"},
    );
  }

  // sudah
  Future<void> userpencarian(pencarian) async {
    await analytics.logEvent(
      name: "user melakukan pencarian",
      parameters: {'pencarian': "user mencari ${pencarian}"},
    );
  }

  //sudah
  Future<void> usertimeout() async {
    await analytics.setSessionTimeoutDuration(Duration(minutes: 1));
  }

  // sudah
  Future<void> userId(id) async {
    await analytics.setUserId(id: id);
  }

  // sudah
  Future<void> userpoperty(email) async {
    await analytics.setUserProperty(name: 'email', value: email);
  }

  Future<void> changeMode(bool isWorkMode) async {
  await analytics.logEvent(
    name: "mode_changed",
    parameters: {
      "mode": isWorkMode ? "Work" : "Hire",
      "timestamp": DateTime.now().toIso8601String(),
    },
  );
}

  Future<void> startTracking(String page) async {
    _screenStartTime = DateTime.now();
    _currentScreenName = page;

    await analytics.logScreenView(screenName: page, screenClass: page);

    print("Tracking started for $page at $_screenStartTime");
  }

  Future<void> endTracking() async {
    if (_screenStartTime == null || _currentScreenName == null) return;

    final duration = DateTime.now().difference(_screenStartTime!).inSeconds;

    await analytics.logEvent(
      name: 'screen_view_duration',
      parameters: {
        'screen_name': _currentScreenName!,
        'duration_seconds': duration,
      },
    );

    print("User spent $duration seconds on $_currentScreenName");

    _screenStartTime = null;
    _currentScreenName = null;
  }
}
