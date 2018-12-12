import 'dart:async';

import '../../models/project.dart';

abstract class ProjectsService {
  Future<List<Project>> getProjects();

  Future<Project> createProject(
    String projectID,
    String name,
    String description,
    double effortLimit,
  );

  Future<Project> updateProject(
    int id,
    String projectID,
    String name,
    String description,
    double effortLimit,
  );

  Future<bool> deleteProject(int id);

  Future<void> changeActiveProject(int id);

  Future<void> updateActiveProject();
}
