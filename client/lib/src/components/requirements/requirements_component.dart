import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/requirement.dart';

import '../../services/requirements/requirements_service.dart';
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
    const ClassProvider(RequirementsService, useClass: MockRequirements)
  ],
)
class RequirementsComponent implements OnInit {
  final RequirementsService requirementsService;

  @Input()
  bool isEditing = true;

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
  void onSelect(Requirement requirement){
    createRequirementPanel = false;
    resetPanel();
    selected = requirement;
  } 

  void createRequirement() async {
    if (!checkRequirement()) return;

    Requirement createRq = await requirementsService.createRequirement(
        requirementIdToAdd, titleToAdd, descriptionToAdd);

    if (createRq != null) createRequirementPanel = false;
  }

// Editar requisito
  void editRequirement() async {
    isEditing = true;
    createRequirementPanel = true;
    requirementIdToAdd = selected.requirementID;
    titleToAdd = selected.title;
    descriptionToAdd = selected.description;
    selected = null;
  }

// Confirmar editar requisito
  void confirmEditRequirement() {
    if (!checkRequirement()) return;
  }

  void deleteRequirement() async {
    bool deleted = await requirementsService.deleteRequirement(selected.id);

    if (deleted) {
      requirements.remove(selected);

      selected = null;
    }
  }

  // Introducir requisito
  void newRequirement() {
    if (createRequirementPanel == true)
      resetPanel();
    else
      createRequirementPanel = true;

    isEditing = false;

    if (selected != null) selected = null;
  }

  // Reiniciar panel
  void resetPanel() {
    if (isEditing == false) createRequirementPanel = false;

    requirementIdToAdd = "";
    titleToAdd = "";
    descriptionToAdd = "";
  }

  //Cancelar edicion requisito
  void cancelEditRequirement() {
    resetPanel();
    isEditing = false;
    createRequirementPanel = false;
  }

  // Comprobar valores
  bool checkRequirement() {
    if (requirementIdToAdd == null ||
        titleToAdd == null ||
        descriptionToAdd == null) return false;

    return true;
  }
}
