import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

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
    coreDirectives,
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
  bool createRequirementPanel = true;
  Project currentProject;

  RequirementsComponent(this.requirementsService);

  @override
  void ngOnInit() async {
    requirements = await requirementsService.getActiveRequirements(currentProject);
  }

  void onSelect(Requirement requirement) => selected = requirement;

  //Añadir requisito al proyecto
  void addRequirementToProject(){
    if (selected == null) return;

    Future<bool> b = requirementsService.addRequirementToProject(selected, currentProject);
  }  
}