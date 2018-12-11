import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:client/src/utils/routing.dart';
import '../../models/project.dart';
import '../../models/project_requirement.dart';
import '../../services/plan/plan_service.dart';
import '../../services/plan/http_plan.dart';
import '../../services/user/user_service.dart';
import '../../services/project_requirements/project_requirements_service.dart';
import '../../services/clients/clients_service.dart';
import '../../models/client.dart';

import '../../utils/routing.dart';


@Component(
  selector: 'plan',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    '../../styles/styles.css',
    '../../styles/requirements_component.css',
  ],
  templateUrl: 'plan_component.html',
  directives: [
    routerDirectives,
    coreDirectives,
    MaterialPersistentDrawerDirective,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
    MaterialInputComponent,
    materialInputDirectives,
    materialNumberInputDirectives,
  ],
  exports: [Paths, Routes],
  providers: [
    const ClassProvider(PlanService,
        useClass: HttpPlan)
  ],
)
class PlanComponent implements OnInit {
  final PlanService planService;
  final UserService userService;
  //final ClientsService clientsService;
  //final ProjectRequirementService projectRequirementService;

  ProjectRequirement selected;
  List<ProjectRequirement> requirements;
  bool someError = false;
  bool errorEstimatedEffort = false;
  bool errorLimitEffort = false;
  Project project;
  String effortLimitProject = "0";
  //List<Client> clients;

  PlanComponent(this.planService, this.userService,);

  @override
  void ngOnInit() async {
    requirements = await planService.getProjectRequirements();
    project = userService.getActiveProject();
    effortLimitProject = project.effortLimit.toString();
    someError = comprobarErrores();
    //clients = await clientsService.getClients();   
  }

  void onSelect(ProjectRequirement requirement) {
    selected = requirement;
  }

  void automaticPlanning(){
    if(comprobarErrores()) return;
  }

  bool comprobarErrores(){
    if(errorEsfuerzoEstimado()) return true;
    if(errorEsfuerzoLimite()) return true;

    return false;
  }

  bool errorEsfuerzoEstimado(){
    errorEstimatedEffort = false;
    for(ProjectRequirement r in requirements){
        if(r.estimatedEffort == 0){
          errorEstimatedEffort = true;
          return true;
        }
    }
    return false;
  }

  bool errorEsfuerzoLimite(){
    errorLimitEffort = false;
    if(project.effortLimit == 0) {
      errorLimitEffort = true;
      return true;
    }
    return false;
  }
}
