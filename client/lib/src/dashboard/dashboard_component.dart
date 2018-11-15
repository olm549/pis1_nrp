import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../model/project.dart';

import './dashboard_service.dart';

@Component(
  selector: 'dashboard',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    'dashboard_component.css',
  ],
  templateUrl: 'dashboard_component.html',
  directives: [
    coreDirectives,
    DeferredContentDirective,
    MaterialPersistentDrawerDirective,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
  ],
  providers: [const ClassProvider(DashboardService)],
)
class DashboardComponent extends OnInit {
  final DashboardService dashboardService;

  Project activeProject;
  String selectedView = 'projects';

  DashboardComponent(this.dashboardService);

  @override
  void ngOnInit() async {
    activeProject = await dashboardService.getActiveProject();
  }

  void onSelectView(String newView) {
    selectedView = newView;
  }
}
