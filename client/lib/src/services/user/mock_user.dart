import 'package:angular/angular.dart';

import '../../models/project.dart';

import './user_service.dart';

@Injectable()
class MockUser extends UserService {
  String _accessToken;
  Project _activeProject;

  void logInUser(String accessToken) {
    _accessToken = accessToken;

    _activeProject = null;
  }

  void logOutUser() {
    _accessToken = null;
    _activeProject = null;
  }

  bool isUserLogged() {
    return _accessToken != null;
  }

  bool isActiveProject() {
    return _activeProject != null;
  }

  String getAccessToken() {
    return _accessToken;
  }

  Project getActiveProject() {
    return _activeProject;
  }

  void changeActiveProject(Project newProject) {
    _activeProject = newProject;
  }
}
