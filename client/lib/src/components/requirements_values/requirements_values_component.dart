import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/requirement_value.dart';
import '../../models/requirement.dart';
import '../../models/client.dart';
import '../../models/project_requirement.dart';
import '../../models/project_client.dart';

import '../../services/requirements/requirements_service.dart';
import '../../services/clients/clients_service.dart';
import '../../services/requirements/mock_requirements.dart';

import '../../utils/routing.dart';

@Component(
  selector: 'requirements',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    '../../styles/styles.css',
    '../../styles/requirements_component.css',
  ],
  templateUrl: 'requirements_values_component.html',
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
   exports: [Paths, Routes],
  providers: [
    const ClassProvider(RequirementsService, useClass: MockRequirements)
  ],
)
class RequirementsComponent implements OnInit {
  final RequirementsService requirementsService;
  final ClientsService clientsService;

  @Input()
  bool isEditing = true;

  Requirement selected;
  List<ProjectRequirement> requirements;
  Client selectedC;
  List<ProjectClient> clients; 
  bool assignValuePanel = false;
  String requirementIdToAdd;
  String titleToAdd;
  String nameToAdd;
  String descriptionToAdd;
  double valueToAdd;

  RequirementsComponent(this.requirementsService, this.clientsService);

  @override
  void ngOnInit() async {
    requirements = await requirementsService.getProjectRequirements();
    clients = await clientsService.getProjectClients();
  }

  //Seleccionar requisito
  void onSelectRequirement(Requirement requirement){
    assignValuePanel = false;
    resetPanel();
    selected = requirement;
  } 

  //Seleccionar cliente
  void onSelectClient(Client client){
    assignValuePanel = false;
    resetPanel();
    selectedC = client;
  } 



  // Reiniciar panel
  void resetPanel() {
    if (isEditing == false) assignValuePanel = false;

    requirementIdToAdd = "";
    titleToAdd = "";
    descriptionToAdd = "";
  }

  // Editar valor de un requisito-cliente
  void editValue() async {
    isEditing = true;
    assignValuePanel = true;
    requirementIdToAdd = selected.requirementID;
    titleToAdd = selected.title;
    descriptionToAdd = selected.description;
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
    if (valueToAdd == null ||
        titleToAdd == null ||
        nameToAdd == null ) return false;

    return true;
  }

}
