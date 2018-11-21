import 'dart:async';

import 'package:angular/angular.dart';

import '../user_service.dart';
import '../http_service.dart';

import './authentication_service.dart';

@Injectable()
class HttpAuthentication implements AuthenticationService {
  final HttpService _httpService;
  final UserService _userService;

  HttpAuthentication(this._httpService, this._userService);

  Future<bool> signIn(String email, String password) async {
    try {
      final response = await _httpService.getClient().post(
            '${_httpService.getUrl()}/auth/token',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Authorization': 'Basic ${_httpService.basicAuth}'
            },
            body: 'username=$email&password=$password&grant_type=password',
          );

      if (response.statusCode == 200) {
        final accessToken = _httpService.extractData(response)['access_token'];

        _userService.logInUser(accessToken);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw _httpService.handleError(e);
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      final response = await _httpService.getClient().post(
        '${_httpService.getUrl()}/register',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${_httpService.basicAuth}'
        },
        body: {
          'username': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // 409 response.
        return false;
      }
    } catch (e) {
      throw _httpService.handleError(e);
    }
  }
}
