import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:client/src/utils/routing.dart';
import '../../models/requirement.dart';
import '../../services/plan/plan_service.dart';
import '../../services/plan/http_plan.dart';
import '../../services/plan/mock_plan.dart';

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

  Requirement selected;
  List<Requirement> requirements;

  double effortToAdd;

  PlanComponent(this.planService);

  @override
  void ngOnInit() async {
    requirements = await planService.getRequirements();
  }

  void onSelect(Requirement requirement) {
    selected = requirement;
  }
}
