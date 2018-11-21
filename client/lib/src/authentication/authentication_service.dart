import 'dart:async';

abstract class AuthenticationService {
  Future<bool> signIn(String email, String password);

  Future<bool> signUp(String email, String password);
}
