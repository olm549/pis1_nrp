import 'dart:async';

import 'package:angular/angular.dart';

import '../loading_service.dart';
import '../user_service.dart';

import './authentication_service.dart';

@Injectable()
class MockAuthentication implements AuthenticationService {
  final LoadingService loadingService;
  final UserService userService;

  MockAuthentication(this.loadingService, this.userService);

  Future<bool> signIn(String email, String password) {
    loadingService.setLoading();

    if (email == 'hola@test.com') {
      return Future.delayed(Duration(seconds: 2), () {
        loadingService.setLoaded();

        userService.logInUser('testtoken');

        return true;
      });
    } else {
      return Future.delayed(Duration(seconds: 2), () {
        loadingService.setLoaded();

        return false;
      });
    }
  }

  Future<bool> signUp(String email, String password) {
    loadingService.setLoading();

    return Future.delayed(Duration(seconds: 2), () {
      loadingService.setLoaded();

      return true;
    });
  }
}
