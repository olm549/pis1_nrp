import 'dart:async';

import 'package:angular/angular.dart';

import '../../models/project.dart';

@Injectable()
class ProjectsService {
  Future<List<Project>> getProjects() async => null;

  Future<Project> createProject(String projectId, String name,
          String description, double effortLimit, bool active) async =>
      null;

  Future<Project> deleteProject(int projectId) async => null;

  Future activateProject(int projectId) async => null;
}
