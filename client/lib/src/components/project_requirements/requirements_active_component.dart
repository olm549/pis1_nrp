import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:client/src/utils/routing.dart';

import '../../models/requirement.dart';
import '../../models/project.dart';
import '../../models/project_requirement.dart';

import '../../services/project_requirements/project_requirements_service.dart';
import '../../services/project_requirements/http_project_requirements.dart';

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
    materialNumberInputDirectives,
  ],
  exports: [Paths, Routes],
  providers: [
    const ClassProvider(ProjectRequirementsService,
        useClass: HttpProjectRequirements)
  ],
)
class RequirementsComponent implements OnInit {
  final ProjectRequirementsService requirementsService;

  String errorMsg;

  bool isEditing = false;

  ProjectRequirement selected;
  List<ProjectRequirement> activeRequirements;

  double effortToAdd;

  RequirementsComponent(this.requirementsService);

  @override
  void ngOnInit() async {
    activeRequirements = await requirementsService.getProjectRequirements();
  }

  void onSelect(ProjectRequirement activeRequirement) {
    selected = activeRequirement;

    isEditing = false;

    errorMsg = null;
  }

  //Elimina un requisito activo
  void removeActiveRequirement() async {
    bool deleted = await requirementsService
        .deleteProjectRequirement(selected.requirement.id);

    if (deleted) {
      activeRequirements.remove(selected);

      selected = null;
      isEditing = false;
    }
  }

  //Abre el panel de editar esfuerzo
  void editEffort() {
    errorMsg = null;
    isEditing = true;

    effortToAdd = selected.estimatedEffort;
  }

  //Edita el peso de un requisito
  void confirmEditEffort() async {
    errorMsg = null;

    if (effortToAdd == null) {
      errorMsg = 'El esfuerzo no puede ser vacío';

      return;
    }

    ProjectRequirement updatedRequirement = await requirementsService
        .updateProjectRequirement(selected.requirement.id, effortToAdd);

    if (updatedRequirement != null) {
      updatedRequirement.requirement = selected.requirement;

      activeRequirements.remove(selected);
      activeRequirements.add(updatedRequirement);

      isEditing = false;

      selected = updatedRequirement;
    }
  }

  void cancelEditEffort() {
    isEditing = false;

    errorMsg = null;
  }
}
