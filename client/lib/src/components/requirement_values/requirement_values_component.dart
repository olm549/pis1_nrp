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
  bool assignValuePanel = false;
  String requirementIdToAdd;
  String titleToAdd;
  String nameToAdd;
  String descriptionToAdd;
  double valueToAdd;

  RequirementsComponent(this.requirementsService);

  @override
  void ngOnInit() async {
    requirements = await requirementsService.getRequirements();
  }

  //Seleccionar requisito
  void onSelect(Requirement requirement){
    assignValuePanel = false;
    resetPanel();
    selected = requirement;
  } 



  // Reiniciar panel
  void resetPanel() {
    if (isEditing == false) assignValuePanel = false;

    requirementIdToAdd = "";
    titleToAdd = "";
    descriptionToAdd = "";
  }

  // Editar valor de un requisito-cliente
  void editRequirement() async {
    isEditing = true;
    assignValuePanel = true;
    requirementIdToAdd = selected.requirementID;
    titleToAdd = selected.title;
    descriptionToAdd = selected.description;
    selected = null;
  }

  //Cancelar edicion valor
  void cancelEditRequirement() {
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
