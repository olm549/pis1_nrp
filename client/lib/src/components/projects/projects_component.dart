import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/project.dart';

import '../../services/projects/projects_service.dart';
import '../../services/projects/http_projects.dart';
import '../../services/projects/mock_projects.dart';

@Component(
  selector: 'projects',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    '../../styles/styles.css',
    '../../styles/projects_component.css',
  ],
  templateUrl: 'projects_component.html',
  directives: [
    coreDirectives,
    formDirectives,
    DeferredContentDirective,
    MaterialPersistentDrawerDirective,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
    MaterialCheckboxComponent,
    MaterialIconComponent,
    MaterialInputComponent,
    materialInputDirectives,
    materialNumberInputDirectives,
  ],
  providers: [const ClassProvider(ProjectsService, useClass: HttpProjects)],
)
class ProjectsComponent implements OnInit {
  final ProjectsService projectsService;

  bool isEditing = false;
  bool isCreating = false;

  Project selected;
  List<Project> projects;

  bool createProjectPanel = false;

  String projectIdToAdd;
  String nameToAdd;
  String descriptionToAdd;
  double effortLimitToAdd;

  ProjectsComponent(this.projectsService);

  @override
  void ngOnInit() async {
    projects = await projectsService.getProjects();
  }

  void onSelect(Project project) {
    createProjectPanel = false;
    isEditing = false;
    isCreating = false;

    selected = project;
  }

  void createProject() async {
    Project createdProject = await projectsService.createProject(
        projectIdToAdd, nameToAdd, descriptionToAdd, effortLimitToAdd);

    if (createdProject != null) {
      createProjectPanel = false;

      projects.add(createdProject);
    }
  }

  void editProject() async {
    isEditing = true;
    isCreating = false;
    createProjectPanel = true;

    projectIdToAdd = selected.projectID;
    nameToAdd = selected.name;
    descriptionToAdd = selected.description;
    effortLimitToAdd = selected.effortLimit;
  }

  void confirmEditProject() async {
    Project updatedProject = await projectsService.updateProject(
      selected.id,
      projectIdToAdd,
      nameToAdd,
      descriptionToAdd,
      effortLimitToAdd,
    );

    if (updatedProject != null) {
      projects.remove(selected);
      projects.add(updatedProject);

      createProjectPanel = false;
      isEditing = false;

      selected = updatedProject;
    }
  }

  void deleteProject() async {
    bool deleted = await projectsService.deleteProject(selected.id);

    if (deleted) {
      projects.remove(selected);

      selected = null;
      isEditing = false;
      createProjectPanel = false;
    }
  }

  void newProject() {
    isEditing = false;
    isCreating = true;
    createProjectPanel = true;

    if (selected != null) selected = null;

    projectIdToAdd = null;
    nameToAdd = null;
    descriptionToAdd = null;
    effortLimitToAdd = null;
  }

  // Método para cerrar la vista de editar proyecto
  void cancelEditProject() {
    isEditing = false;
    isCreating = false;
    createProjectPanel = false;
  }

  void activateProject() async {
    await projectsService.changeActiveProject(selected.id);

    selected = null;

    // TODO: No funciona, arreglar implementación.
    projects.setAll(0, await projectsService.getProjects());
  }
}
