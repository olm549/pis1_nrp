import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/project.dart';

import '../../services/projects/projects_service.dart';
import '../../services/projects/mock_projects.dart';

@Component(
  selector: 'projects',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    'projects_component.css',
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
  ],
  providers: [const ClassProvider(ProjectsService, useClass: MockProjects)],
)
class ProjectsComponent {
  final ProjectsService projectsService;

  @Input()
  bool isEditing = true;

  Project selected;
  List<Project> projects;

  bool createProjectPanel = false;

  String projectIdToAdd;
  String nameToAdd;
  String descriptionToAdd;
  double effortLimitToAdd;
  bool activeToAdd;

  ProjectsComponent(this.projectsService);

  void onSelect(Project project) {
    createProjectPanel = false;
    resetPanel();
    selected = project;
  }

  void createProject() async {
    if (!comprobarProject()) return;

    Project createProject = await projectsService.createProject(projectIdToAdd,
        nameToAdd, descriptionToAdd);

    if (createProject != null) createProjectPanel = false;
  }

  void editProject() async {
    isEditing = true;
    createProjectPanel = true;

    projectIdToAdd = selected.projectID;
    nameToAdd = selected.name;
    descriptionToAdd = selected.description;
    effortLimitToAdd = selected.effortLimit;
    activeToAdd = selected.active;

    selected = null;
  }

  void confirmEditProject() {
    if (!comprobarProject()) return;
  }

  void deleteProject() async {
    bool deleted = await projectsService.deleteProject(selected.id);

    if(deleted) {
      projects.remove(selected);

      selected = null;
    }
  }

  void newProject() {
    if (createProjectPanel == true)
      resetPanel();
    else
      createProjectPanel = true;

    isEditing = false;

    if (selected != null) selected = null;
  }

  void resetPanel() {
    if (isEditing == false) createProjectPanel = false;
    projectIdToAdd = "";
    nameToAdd = "";
    descriptionToAdd = "";
    effortLimitToAdd = 0.0;
  }

  // Método para cerrar la vista de editar proyecto
  void cancelEditProject() {
    resetPanel();
    isEditing = false;
    createProjectPanel = false;
  }

  bool comprobarProject() {
    if (projectIdToAdd == null ||
        nameToAdd == null ||
        descriptionToAdd == null ||
        effortLimitToAdd == null ||
        activeToAdd == null) return false;

    return true;
  }

  void activateProject() {
    // TODO: llamada a método updateProject del proyecto activo para establecer su propiedad active a 'false'
    projectsService.updateProject(selected.id, selected.projectID, selected.name, selected.description, selected.effortLimit, true);
  }
}
