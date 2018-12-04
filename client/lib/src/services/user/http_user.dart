import 'package:angular/angular.dart';

import '../../models/project.dart';

import '../http_service.dart';

import './user_service.dart';

@Injectable()
class HttpUser extends UserService {
  HttpService _httpService;

  String _accessToken;
  Project _activeProject;

  HttpUser(this._httpService);

  void logInUser(String accessToken) {
    _accessToken = accessToken;

    _fetchActiveProject().then((project) => _activeProject = project);
  }

  Future<Project> _fetchActiveProject() async {
    try {
      final response = await _httpService.getClient().get(
        '${_httpService.getUrl()}/projects/active',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${getAccessToken()}'
        },
      );

      if (response.statusCode == 200) {
        final activeProject =
            Project.fromJson(_httpService.extractData(response));

        return activeProject;
      } else {
        // 404 response.
        return null;
      }
    } catch (e) {
      throw _httpService.handleError(e);
    }
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

  void changeActiveProject(int id) {
    _updateActiveProject(id).then((project) => _activeProject = project);
  }

  Future<Project> _updateActiveProject(int id) async {
    try {
      final response = await _httpService.getClient().put(
        '${_httpService.getUrl()}/projects/active?newID=$id',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${getAccessToken()}',
        },
      );

      if (response.statusCode == 200) {
        final newActiveProject =
            Project.fromJson(_httpService.extractData(response));

        return newActiveProject;
      } else {
        return _activeProject;
      }
    } catch (e) {
      throw _httpService.handleError(e);
    }
  }
}
