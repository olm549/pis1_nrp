import 'dart:async';

import 'package:angular/angular.dart';

import '../user_service.dart';

import './authentication_service.dart';

@Injectable()
class AuthenticationMock implements AuthenticationService {
  final UserService userService;

  AuthenticationMock(this.userService);

  Future<bool> signIn(String email, String password) {
    if (email == 'hola@test.com') {
      return Future.delayed(Duration(seconds: 2), () {
        userService.logInUser('testtoken');

        return true;
      });
    } else {
      return Future.delayed(Duration(seconds: 2), () => false);
    }
  }

  Future<bool> signUp(String email, String password) {
    return Future.delayed(Duration(seconds: 2), () => true);
  }
}
