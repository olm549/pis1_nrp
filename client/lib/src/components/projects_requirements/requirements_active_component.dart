import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:client/src/utils/routing.dart';

import '../../models/requirement.dart';
import '../../models/project.dart';
import '../../models/project_requirement.dart';

import '../../services/requirements/requirements_service.dart';
import '../../services/requirements/mock_requirements.dart';

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
  ],
  exports: [Paths, Routes],
  providers: [
    const ClassProvider(RequirementsService, useClass: MockRequirements)
  ],
)
class RequirementsComponent implements OnInit {
  final RequirementsService requirementsService;

  @Input()
  
  ProjectRequirement selected;
  List<ProjectRequirement> activeRequirements;
  bool createRequirementPanel = true;
  Project currentProject;
  bool isEditing = false;
  List<Project> projectsRequirement;  //Lista de proyectos a los que pertenece
  String effortToAdd;

  RequirementsComponent(this.requirementsService);

  @override
  void ngOnInit() async {
    activeRequirements = await requirementsService.getProjectRequirements();
  }

  void onSelect(ProjectRequirement activeRequirement){
    getProjectsFromRequirement(activeRequirement.requirement);
    createRequirementPanel = true;
    selected = activeRequirement;
    isEditing = false;
  }

  //Añadir requisito al proyecto
  void addRequirementToProject(){
    if (selected == null) return;

    Future<bool> b = requirementsService.addRequirementToProject(selected);
  } 

  void removeActiveRequirement() async{
    bool deleteActiveRequirement = await requirementsService.deleteActiveRequirement(selected.id);

    if (deleteActiveRequirement) {
      activeRequirements.remove(selected);
      selected = null;
    }
  }

    void getProjectsFromRequirement(Requirement requirement){

    projectsRequirement = requirementsService.getProjectsFromRequirement(requirement);
    
  }

  void editEffort(){
    if (isEditing == false){
      isEditing = true;
    }else{
      isEditing = false;
    }
  }

  void confirmEditEffort() async{
    if (effortToAdd == null || effortToAdd == "") return;
    double effort;
    try{
      effort = double.parse(effortToAdd);
    }catch(e){
      return;
    }

    bool effortEdited = await requirementsService.updateEffortClient(selected.id, effort);
    if(effortEdited){
      isEditing = false;
      selected.estimatedEffort = effort;
    }

  }
}