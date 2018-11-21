class UserService {
  String _accessToken;

  void logInUser(String accessToken) {
    _accessToken = accessToken;
  }

  void logOutUser() {
    _accessToken = null;
  }

  bool isUserLogged() {
    return _accessToken != null;
  }

  String getAccessToken() {
    return _accessToken;
  }
}
