import 'offline_service.dart';

class AuthService {
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    return await MockAuthService.signUp(email, password);
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    return await MockAuthService.signIn(email, password);
  }

  Future<void> signOut() async {
    await MockAuthService.signOut();
  }

  bool isLoggedIn() {
    return MockAuthService.isLoggedIn;
  }

  String? getCurrentUserEmail() {
    return MockAuthService.currentUserEmail;
  }
}
