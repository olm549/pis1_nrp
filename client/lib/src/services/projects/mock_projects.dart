import 'dart:async';

import 'package:angular/angular.dart';

import '../../models/project.dart';

import './projects_service.dart';

@Injectable()
class MockProjects implements ProjectsService {
  final projects = <Project>[
    Project(1, 'P001', 'Hola', 'Adios', 3.0, false),
    Project(2, 'P002', 'PRIS2018', 'Proyecto de la asignatura', 5.0, false),
    Project(3, 'P003', 'PRIS', 'Sin descripción', 4.2, false),
    Project(4, 'P004', 'Procesos de Ingeniería del Software', 'NRP', 7.8, false)
  ];

  Future<List<Project>> getProjects() async {
    return projects;
  }

  Future<Project> createProject(
    String projectID,
    String name,
    String description,
    double effortLimit,
  ) async {
    return Project(20, projectID, name, description, effortLimit, false);
  }

  Future<Project> updateProject(
    int id,
    String projectID,
    String name,
    String description,
    double effortLimit,
    bool active,
  ) async {
    return Project(id, projectID, name, description, effortLimit, active);
  }

  Future<bool> deleteProject(int id) async {
    return Future.sync(() => true);
  }

  Future<void> changeActiveProject(int id) {
    return null;
  }
}
