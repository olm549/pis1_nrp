import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/requirement.dart';

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

  bool isEditing = false;
  bool isCreating = false;

  Requirement selected;
  List<Requirement> requirements;

  bool createRequirementPanel = false;

  String requirementIdToAdd;
  String titleToAdd;
  String descriptionToAdd;

  RequirementsComponent(this.requirementsService);

  @override
  void ngOnInit() async {
    requirements = await requirementsService.getRequirements();
  }

  //Seleccionar requisito
  void onSelect(Requirement requirement) {
    createRequirementPanel = false;
    isEditing = false;
    isCreating = false;

    selected = requirement;
  }

  void createRequirement() async {
    Requirement createdRequirement = await requirementsService
        .createRequirement(requirementIdToAdd, titleToAdd, descriptionToAdd);

    if (createdRequirement != null) {
      createRequirementPanel = false;

      requirements.add(createdRequirement);
    }
  }

// Editar requisito
  void editRequirement() async {
    isEditing = true;
    isCreating = false;
    createRequirementPanel = true;

    requirementIdToAdd = selected.requirementID;
    titleToAdd = selected.title;
    descriptionToAdd = selected.description;
  }

// Confirmar editar requisito
  void confirmEditRequirement() async {
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
    isEditing = false;
    isCreating = true;
    createRequirementPanel = true;

    if (selected != null) selected = null;

    requirementIdToAdd = null;
    titleToAdd = null;
    descriptionToAdd = null;
  }

  //Cancelar edicion requisito
  void cancelEditRequirement() {
    isEditing = false;
    isCreating = false;
    createRequirementPanel = false;
  }

  void addToActiveProject() async {
    await requirementsService.addRequirementToProject(selected.id);
  }
}
