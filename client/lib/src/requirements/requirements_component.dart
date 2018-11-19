import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../model/requirement.dart';
import 'mock_requirements.dart';

import './requirements_service.dart';

@Component(
  selector: 'requirements',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    'requirements_component.css',
  ],
  templateUrl: 'requirements_component.html',
  directives: [
    coreDirectives,
    MaterialPersistentDrawerDirective,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
    MaterialInputComponent,
    materialInputDirectives,
  ],
  providers: [const ClassProvider(RequirementsService)],
)
class RequirementsComponent {
  final RequirementsService requirementsService;

  @Input() bool isEditing = true;



  Requirement selected;
  List<Requirement> requirements = mockRequirements;
  bool createRequirementPanel = false;
  String requirementIdToAdd;
  String titleToAdd;
  String descriptionToAdd;
  

  RequirementsComponent(this.requirementsService);

  void onSelect(Requirement requirement) => selected = requirement;

  void createRequirement() async {

    if(!checkRequirement()) return;
    Requirement createRq = await requirementsService.createRequirement(requirementIdToAdd,titleToAdd,descriptionToAdd);
    if(createRq != null) createRequirementPanel = false;
    //await requirementsService.createRequirement();
  }

//Editar requisito
  void editRequirement() async{

    isEditing = true;
    createRequirementPanel = true;
    requirementIdToAdd = selected.requirementID;
    titleToAdd = selected.title;
    descriptionToAdd = selected.description;
    selected = null;
  }

//Confirmar editar requisito
  void confirmEditRequirement(){
    if(!checkRequirement()) return;
  }

  /*
  * Método para abrir el panel de introducir
  * formulario para agregar un requisito
  */
  void newRequirement(){
    
    if(createRequirementPanel == true) resetPanel();
    else createRequirementPanel = true;
    isEditing = false;
    if(selected!=null) selected = null;
    
  }

  /*
  * Resetear valores del panel
  */
  void resetPanel(){
    if(isEditing==false) createRequirementPanel = false;  
    requirementIdToAdd = "";
    titleToAdd = "";
    descriptionToAdd = "";
   
  }

  /*
  * Método para cerrar la vista
  * de editar requisito
  */
  void cancelEditRequirement(){
    resetPanel();
    isEditing = false;
    createRequirementPanel = false;
  }

  /*
  * Método para comprobar los
  * valores del formulario
  */
  bool checkRequirement(){

    if(requirementIdToAdd==null || titleToAdd == null || descriptionToAdd == null) return false;
    
    return true;
  }
}
