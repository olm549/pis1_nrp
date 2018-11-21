class UserService {
  String _accessToken;

  logInUser(String accessToken) {
    _accessToken = accessToken;
  }

  logOutUser() {
    _accessToken = null;
  }

  bool isUserLogged() {
    return _accessToken != null;
  }

  String getAccessToken() {
    return _accessToken;
  }
}
