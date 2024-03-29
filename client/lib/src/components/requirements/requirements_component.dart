import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/requirement.dart';
import '../../models/project.dart';

import '../../services/requirements/requirements_service.dart';
import '../../services/requirements/http_requirements.dart';
import '../../services/requirements/mock_requirements.dart';

@Component(
  selector: 'requirements',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    '../../styles/styles.css',
    '../../styles/requirements_component.css',
  ],
  templateUrl: 'requirements_component.html',
  directives: [
    coreDirectives,
    formDirectives,
    MaterialPersistentDrawerDirective,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
    MaterialInputComponent,
    materialInputDirectives,
  ],
  providers: [
    const ClassProvider(RequirementsService, useClass: HttpRequirements)
  ],
)
class RequirementsComponent implements OnInit {
  final RequirementsService requirementsService;

  String errorMsg;
  String addToActiveProjectSuccessMsg;
  String addToActiveProjectErrorMsg;

  bool isEditing = false;
  bool isCreating = false;

  Requirement selected;
  List<Requirement> requirements;
  List<Project> reqProjects;

  bool createRequirementPanel = false;

  String requirementIdToAdd = '';
  String titleToAdd = '';
  String descriptionToAdd = '';

  RequirementsComponent(this.requirementsService);

  @override
  void ngOnInit() async {
    requirements = await requirementsService.getRequirements();
  }

  //Seleccionar requisito
  void onSelect(Requirement requirement) async {
    addToActiveProjectSuccessMsg = null;
    addToActiveProjectErrorMsg = null;

    createRequirementPanel = false;
    isEditing = false;
    isCreating = false;

    reqProjects =
        await requirementsService.getRequirementProjects(requirement.id);
    selected = requirement;
  }

  void createRequirement() async {
    errorMsg = null;

    if (requirementIdToAdd.isEmpty ||
        titleToAdd.isEmpty ||
        descriptionToAdd.isEmpty) {
      errorMsg = 'Por favor, rellena todos los campos.';

      return;
    }

    Requirement createdRequirement = await requirementsService
        .createRequirement(requirementIdToAdd, titleToAdd, descriptionToAdd);

    if (createdRequirement != null) {
      createRequirementPanel = false;

      requirements.add(createdRequirement);
    } else {
      errorMsg = 'El ID de ese requisito ya existe. Escoge otro.';
    }
  }

// Editar requisito
  void editRequirement() async {
    errorMsg = null;
    isEditing = true;
    isCreating = false;
    createRequirementPanel = true;

    requirementIdToAdd = selected.requirementID;
    titleToAdd = selected.title;
    descriptionToAdd = selected.description;
  }

// Confirmar editar requisito
  void confirmEditRequirement() async {
    errorMsg = null;

    if (requirementIdToAdd.isEmpty ||
        titleToAdd.isEmpty ||
        descriptionToAdd.isEmpty) {
      errorMsg = 'Por favor, rellena todos los campos.';

      return;
    }

    Requirement updatedRequirement =
        await requirementsService.updateRequirement(
      selected.id,
      requirementIdToAdd,
      titleToAdd,
      descriptionToAdd,
    );

    if (updatedRequirement != null) {
      requirements.remove(selected);
      requirements.add(updatedRequirement);

      createRequirementPanel = false;
      isEditing = false;

      selected = updatedRequirement;
    } else {
      errorMsg = 'El ID de ese requisito ya existe. Escoge otro.';
    }
  }

  void deleteRequirement() async {
    bool deleted = await requirementsService.deleteRequirement(selected.id);

    if (deleted) {
      requirements.remove(selected);

      selected = null;
      isEditing = false;
      createRequirementPanel = false;
    }
  }

  // Introducir requisito
  void newRequirement() {
    addToActiveProjectSuccessMsg = null;
    addToActiveProjectErrorMsg = null;
    errorMsg = null;

    isEditing = false;
    isCreating = true;
    createRequirementPanel = true;

    if (selected != null) selected = null;

    requirementIdToAdd = '';
    titleToAdd = '';
    descriptionToAdd = '';
  }

  //Cancelar edicion requisito
  void cancelEditRequirement() {
    isEditing = false;
    isCreating = false;
    createRequirementPanel = false;
  }

  void addToActiveProject() async {
    addToActiveProjectSuccessMsg = null;
    addToActiveProjectErrorMsg = null;

    bool succesful =
        await requirementsService.addRequirementToProject(selected.id);
    if (succesful) {
      addToActiveProjectSuccessMsg = 'Requisito añadido al proyecto.';
    } else {
      addToActiveProjectErrorMsg = 'El requisito ya está en el proyecto.';
    }
  }
}
