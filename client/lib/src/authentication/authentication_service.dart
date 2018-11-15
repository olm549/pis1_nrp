import 'dart:async';

import 'package:angular/angular.dart';

import '../model/user.dart';

@Injectable()
class AuthenticationService {
  Future<User> signIn(String email, String password) async => null;

  Future<bool> singUp(String email, String password) async => null;
}
