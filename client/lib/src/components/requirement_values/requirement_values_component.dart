import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/requirement_value.dart';
import '../../models/project_requirement.dart';
import '../../models/project_client.dart';

import '../../services/requirements/requirements_service.dart';
import '../../services/clients/clients_service.dart';
import '../../services/requirements/mock_requirements.dart';

import '../../utils/routing.dart';

@Component(
  selector: 'requirement-values',
  styleUrls: const [
    '../../styles/styles.css',
  ],
  templateUrl: 'requirement_values_component.html',
  directives: [
    coreDirectives,
    formDirectives,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
    MaterialInputComponent,
    materialInputDirectives,
  ],
  exports: [Paths, Routes],
  providers: [
    const ClassProvider(RequirementsService, useClass: MockRequirements)
  ],
)
class RequirementValuesComponent implements OnInit {
  final RequirementsService requirementsService;
  final ClientsService clientsService;

  @Input()
  bool isEditing = true;

  ProjectRequirement selected;
  List<ProjectRequirement> requirements;
  ProjectClient selectedC;
  List<ProjectClient> clients;
  List<RequirementValue> values;
  RequirementValue reValue;
  bool assignValuePanel = false;
  int requirementIdToAdd;
  String titleToAdd;
  String nameToAdd;
  String descriptionToAdd;
  double valueToAdd;

  RequirementValuesComponent(this.requirementsService, this.clientsService);

  @override
  void ngOnInit() async {
    requirements = await requirementsService.getProjectRequirements();
    clients = await clientsService.getProjectClients();
  }

  //Seleccionar requisito
  void onSelectRequirement(ProjectRequirement requirement) {
    assignValuePanel = false;
    resetPanel();
    selected = requirement;
    isEditing = false;
  }

  //Seleccionar cliente
  void onSelectRequirementValue(RequirementValue value) {
    assignValuePanel = false;
    resetPanel();
    reValue = value;
    isEditing = false;
  }

  // Reiniciar panel
  void resetPanel() {
    if (isEditing == false) assignValuePanel = false;

    requirementIdToAdd = "" as int;
    titleToAdd = "";
    descriptionToAdd = "";
  }

  // Editar valor de un requisito-cliente
  void editValue() async {
    isEditing = true;
    assignValuePanel = true;
    requirementIdToAdd = reValue.id;
    titleToAdd = reValue.requirement as String;
    descriptionToAdd = reValue.client as String;
    selected = null;
  }

  //Cancelar edicion valor
  void cancelEditValue() {
    resetPanel();
    isEditing = false;
    assignValuePanel = false;
  }

  // Confirmar editar valor
  void confirmEditValue() {
    if (!checkValue()) return;
  }

  // Comprobar campos en blanco
  bool checkValue() {
    if (valueToAdd == null || titleToAdd == null || nameToAdd == null)
      return false;

    return true;
  }
}
