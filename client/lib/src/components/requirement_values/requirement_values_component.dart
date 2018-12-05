import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/requirement_value.dart';
import '../../models/project_requirement.dart';
import '../../models/project_client.dart';

import '../../services/project_requirements/project_requirements_service.dart';
import '../../services/project_requirements/http_project_requirements.dart';
import '../../services/project_requirements/mock_project_requirements.dart';
import '../../services/project_clients/project_clients_service.dart';
import '../../services/project_clients/http_project_clients.dart';
import '../../services/project_clients/mock_project_clients.dart';

//import '../../utils/routing.dart';

@Component(
  selector: 'requirement-values',
  styleUrls: const [
    '../../styles/styles.css',
    '../../styles/requirement_values_component.css',
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
  //exports: [Paths, Routes],
  providers: [
    const ClassProvider(ProjectRequirementService,
        useClass: HttpProjectRequirements),
    const ClassProvider(ProjectClientsService, useClass: HttpProjectClients),
  ],
)
class RequirementValuesComponent implements OnInit {
  final ProjectRequirementService requirementsService;
  final ProjectClientsService clientsService;

  @Input()
  bool isEditing = true;

  ProjectRequirement selectedReq;
  List<ProjectRequirement> requirements;
  ProjectClient selectedClient;
  List<ProjectClient> clients;
  List<RequirementValue> values;
  RequirementValue reValue;
  bool assignValuePanel = false;

  double valueToAdd;

  RequirementValuesComponent(this.requirementsService, this.clientsService);

  @override
  void ngOnInit() async {
    requirements = await requirementsService.getProjectRequirements();
    clients = await clientsService.getProjectClients();
  }

  //Seleccionar requisito
  void onSelectRequirement(ProjectRequirement requirement) {
    assignValuePanel = true;
    selectedReq = requirement;
    selectedClient = null;
    isEditing = true;
  }

  //Seleccionar cliente
  void onSelectClient(ProjectClient client) {
    assignValuePanel = true;
    selectedClient = client;
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
  }

  // Editar valor de un requisito-cliente
  void editValue() async {
    isEditing = true;
    assignValuePanel = true;
    valueToAdd = reValue.value;
    selectedReq = null;
    reValue = null;
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
    if (valueToAdd == null) return false;

    return true;
  }
}
