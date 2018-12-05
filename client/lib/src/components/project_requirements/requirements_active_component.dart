import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:client/src/utils/routing.dart';

import '../../models/requirement.dart';
import '../../models/project.dart';
import '../../models/project_requirement.dart';

import '../../services/project_requirements/project_requirements_service.dart';
import '../../services/project_requirements/http_project_requirements.dart';
import '../../services/project_requirements/mock_project_requirements.dart';

@Component(
  selector: 'requirements',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    '../../styles/styles.css',
    '../../styles/requirements_component.css',
  ],
  templateUrl: 'requirements_active_component.html',
  directives: [
    routerDirectives,
    coreDirectives,
    MaterialPersistentDrawerDirective,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
    MaterialInputComponent,
    materialInputDirectives,
  ],
  exports: [Paths, Routes],
  providers: [
    const ClassProvider(ProjectRequirementService,
        useClass: HttpProjectRequirements)
  ],
)
class RequirementsComponent implements OnInit {
  final ProjectRequirementService requirementsService;

  @Input()
  ProjectRequirement selected;
  List<ProjectRequirement> activeRequirements;
  bool createRequirementPanel = true;
  Project currentProject;
  bool isEditing = false;
  //List<Project> projectsRequirement; //Lista de proyectos a los que pertenece
  String effortToAdd;

  RequirementsComponent(this.requirementsService);

  @override
  void ngOnInit() async {
    activeRequirements = await requirementsService.getProjectRequirements();
  }

  void onSelect(ProjectRequirement activeRequirement) {
    //getProjectsFromRequirement(activeRequirement.requirement);
    createRequirementPanel = true;
    selected = activeRequirement;
    isEditing = false;
  }

  //Elimina un requisito activo
  void removeActiveRequirement() async {
    bool deleteActiveRequirement =
        await requirementsService.deleteProjectRequirement(selected.id);

    if (deleteActiveRequirement) {
      activeRequirements.remove(selected);
      selected = null;
    }
  }

  //Devuelve los proyectos a los que pertenece un requisito
  void getProjectsFromRequirement(Requirement requirement) {
    //projectsRequirement =
    //requirementsService.getProjectsFromRequirement(requirement);
  }

  //Abre el panel de editar esfuerzo
  void editEffort() {
    if (isEditing == false) {
      isEditing = true;
    } else {
      isEditing = false;
      effortToAdd = null;
    }
  }

  //Edita el peso de un requisito
  void confirmEditEffort() async {
    if (effortToAdd == null || effortToAdd == "") return;
    double effort;
    try {
      effort = double.parse(effortToAdd);
    } catch (e) {
      return;
    }

    ProjectRequirement updatedRequirement =
        await requirementsService.updateProjectRequirement(selected.id, effort);
    if (updatedRequirement != null) {
      isEditing = false;
      selected.estimatedEffort = effort;
    }
  }
}
