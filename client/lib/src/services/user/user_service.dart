import '../../models/project.dart';

abstract class UserService {
  void logInUser(String accessToken);

  void logOutUser();

  bool isUserLogged();

  bool isActiveProject();

  String getAccessToken();

  Project getActiveProject();

  void changeActiveProject(int id);

  void updateActiveProject();
}
