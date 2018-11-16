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
  ],
  providers: [const ClassProvider(RequirementsService)],
)
class RequirementsComponent {
  final RequirementsService requirementsService;

  Requirement selected;
  List<Requirement> requirements = mockRequirements;

  RequirementsComponent(this.requirementsService);

  void onSelect(Requirement requirement) => selected = requirement;

  void createRequirement() async {
    await requirementsService.createRequirement();
  }
}
