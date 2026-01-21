import 'package:firebase_auth/firebase_auth.dart';
import 'package:no_poverty/services/auth_services_contract.dart';

class FakeAuthFail implements AuthServicesContract {
  @override
  Future<User?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return null; 
  }
  @override
    Future<User?> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return null; 
  }
}

class FakeUser implements User {
  @override
  String get uid => 'fake_uid';

  @override
  String? get email => 'test@email.com';

  @override noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeAuthSuccess implements AuthServicesContract {
  @override
  Future<User?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return FakeUser();
  }

  @override
  Future<User?> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return FakeUser();
  }
}
