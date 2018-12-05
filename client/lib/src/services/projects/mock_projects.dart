import 'dart:async';

import 'package:angular/angular.dart';

import '../../models/project.dart';

import './projects_service.dart';

@Injectable()
class MockProjects implements ProjectsService {
  final projects = <Project>[
    Project(
      id: 1,
      projectID: 'P001',
      name: 'Hola',
      description: 'Adios',
      effortLimit: 3.0,
      active: false,
    ),
    Project(
      id: 2,
      projectID: 'P002',
      name: 'PRIS2018',
      description: 'Proyecto de la asignatura',
      effortLimit: 5.0,
      active: false,
    ),
    Project(
      id: 3,
      projectID: 'P003',
      name: 'PRIS',
      description: 'Sin descripción',
      effortLimit: 4.2,
      active: false,
    ),
    Project(
      id: 4,
      projectID: 'P004',
      name: 'Procesos de Ingeniería del Software',
      description: 'NRP',
      effortLimit: 7.8,
      active: false,
    )
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
    return Project(
      id: 20,
      projectID: projectID,
      name: name,
      description: description,
      effortLimit: effortLimit,
      active: false,
    );
  }

  Future<Project> updateProject(
    int id,
    String projectID,
    String name,
    String description,
    double effortLimit,
    bool active,
  ) async {
    return Project(
      id: id,
      projectID: projectID,
      name: name,
      description: description,
      effortLimit: effortLimit,
      active: active,
    );
  }

  Future<bool> deleteProject(int id) async {
    return Future.sync(() => true);
  }

  Future<void> changeActiveProject(int id) {
    return null;
  }
}
