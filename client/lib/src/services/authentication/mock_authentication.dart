import 'dart:async';

import 'package:angular/angular.dart';

import '../user_service.dart';

import './authentication_service.dart';

@Injectable()
class MockAuthentication implements AuthenticationService {
  final UserService userService;

  MockAuthentication(this.userService);

  Future<bool> signIn(String email, String password) {
    if (email == 'hola@test.com') {
      return Future.sync(() {
        userService.logInUser('testtoken');

        return true;
      });
    } else {
      return Future.sync(() {
        return false;
      });
    }
  }

  Future<bool> signUp(String email, String password) {
    return Future.sync(() {
      return true;
    });
  }
}
