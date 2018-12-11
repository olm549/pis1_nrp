import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:client/src/services/requirement_values/http_requirement_values.dart';
import 'package:client/src/services/requirement_values/requirement_values_service.dart';

import '../../models/requirement_value.dart';
import '../../models/project_requirement.dart';

import '../../services/project_requirements/project_requirements_service.dart';
import '../../services/project_requirements/http_project_requirements.dart';
import '../../services/project_clients/project_clients_service.dart';
import '../../services/project_clients/http_project_clients.dart';

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
    materialNumberInputDirectives,
  ],
  providers: [
    const ClassProvider(ProjectRequirementService,
        useClass: HttpProjectRequirements),
    const ClassProvider(ProjectClientsService, useClass: HttpProjectClients),
    const ClassProvider(RequirementValuesService,
        useClass: HttpRequirementValues),
  ],
)
class RequirementValuesComponent implements OnInit {
  final ProjectRequirementService requirementsService;
  final ProjectClientsService clientsService;
  final RequirementValuesService requirementValuesService;

  String errorMsg;

  bool isEditing = false;

  ProjectRequirement selectedReq;
  List<ProjectRequirement> requirements;
  List<RequirementValue> values;
  RequirementValue selectedValue;

  double valueToAdd;

  RequirementValuesComponent(this.requirementsService, this.clientsService,
      this.requirementValuesService);

  @override
  void ngOnInit() async {
    requirements = await requirementsService.getProjectRequirements();
  }

  //Seleccionar requisito
  void onSelectRequirement(ProjectRequirement projectRequirement) async {
    selectedReq = projectRequirement;
    selectedValue = null;
    values = await requirementValuesService
        .getValues(projectRequirement.requirement.id);
    print(values.length);
    isEditing = false;
  }

  //Seleccionar cliente
  void onSelectValue(RequirementValue value) {
    selectedValue = value;
    isEditing = false;
  }

  // Editar valor de un requisito-cliente
  void editValue() async {
    errorMsg = null;
    isEditing = true;

    valueToAdd = selectedValue.value;
  }

  //Cancelar edicion valor
  void cancelEditValue() {
    isEditing = false;
  }

  // Confirmar editar valor
  Future confirmEditValue() async {
    errorMsg = null;

    if (valueToAdd == null) {
      errorMsg = 'El valor no puede estar vacío';

      return;
    }

    RequirementValue updatedValue = await requirementValuesService.updateValue(
      selectedValue.requirement.id,
      selectedValue.client.id,
      valueToAdd,
    );

    if (updatedValue != null) {
      updatedValue.requirement = selectedValue.requirement;
      updatedValue.client = selectedValue.client;

      values.remove(selectedValue);
      values.add(updatedValue);

      isEditing = false;

      selectedValue = updatedValue;
    }
  }
}
