import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../model/project.dart';
import 'mock_projects.dart';

import './projects_service.dart';

@Component(
  selector: 'projects',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    'projects_component.css',
  ],
  templateUrl: 'projects_component.html',
  directives: [
    coreDirectives,
    DeferredContentDirective,
    MaterialPersistentDrawerDirective,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
  ],
  providers: [const ClassProvider(ProjectsService)],
)
class ProjectsComponent {
  final ProjectsService projectsService;

  Project selected;
  List<Project> projects = mockProjects;

  ProjectsComponent(this.projectsService);

  void onSelect(Project project) => selected = project;

  void createProject() async {
    await projectsService.createProject();
  }
}
