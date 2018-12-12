import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import '../../models/project.dart';
import '../../models/project_requirement.dart';
import '../../models/project_client.dart';
import '../../models/requirement_value.dart';

import '../../services/plan/plan_service.dart';
import '../../services/plan/http_plan.dart';
import '../../services/user/user_service.dart';
import '../../services/project_requirements/project_requirements_service.dart';
import '../../services/project_requirements/http_project_requirements.dart';
import '../../services/project_clients/project_clients_service.dart';
import '../../services/project_clients/http_project_clients.dart';
import '../../services/requirement_values/requirement_values_service.dart';
import '../../services/requirement_values/http_requirement_values.dart';

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
    const ClassProvider(PlanService, useClass: HttpPlan),
    const ClassProvider(ProjectRequirementsService,
        useClass: HttpProjectRequirements),
    const ClassProvider(ProjectClientsService, useClass: HttpProjectClients),
    const ClassProvider(RequirementValuesService,
        useClass: HttpRequirementValues)
  ],
)
class PlanComponent implements OnInit {
  final PlanService planService;
  final ProjectRequirementsService requirementsService;
  final ProjectClientsService clientsService;
  final RequirementValuesService valuesService;

  String errorMsg;

  Project project;
  ProjectRequirement selected;
  List<ProjectRequirement> activeRequirements;
  List<ProjectClient> activeClients;
  Map<ProjectRequirement, String> symbols = {};

  PlanComponent(
    this.planService,
    this.requirementsService,
    this.clientsService,
    this.valuesService,
  );

  @override
  void ngOnInit() async {
    project = planService.getActiveProject();
    activeRequirements = await requirementsService.getProjectRequirements();
    activeClients = await clientsService.getProjectClients();

    await comprobarErrores();
  }

  void onSelect(ProjectRequirement requirement) {
    selected = requirement;
  }

  void plan() async {
    symbols = {};

    final selectedRequirements = await planService.getPlan();

    for (ProjectRequirement pr in activeRequirements) {
      if (selectedRequirements.contains(pr)) {
        symbols.putIfAbsent(pr, () => '👍');
      } else {
        symbols.putIfAbsent(pr, () => '👎');
      }
    }
  }

  void comprobarErrores() async {
    if (project.effortLimit == 0) {
      errorMsg = 'El esfuerzo límite del proyecto es 0';
    } else if (errorRequisitos()) {
      errorMsg = 'Uno o más requisitos con esfuerzo estimado 0';
    } else if (errorClientes()) {
      errorMsg = 'Uno o más clientes con peso 0';
    } else if (await errorValores()) {
      errorMsg =
          'Uno o más clientes no han asignado ningún valor a ningún requisito';
    }
  }

  bool errorRequisitos() {
    for (ProjectRequirement requirement in activeRequirements) {
      if (requirement.estimatedEffort == 0) {
        return true;
      }
    }

    return false;
  }

  bool errorClientes() {
    for (ProjectClient client in activeClients) {
      if (client.weight == 0) {
        return true;
      }
    }

    return false;
  }

  Future<bool> errorValores() async {
    for (ProjectRequirement pr in activeRequirements) {
      final values = await valuesService.getValues(pr.requirement.id);

      double sum = 0;

      for (RequirementValue rv in values) {
        sum += rv.value;
      }

      if (sum == 0) {
        return true;
      }
    }

    return false;
  }
}
