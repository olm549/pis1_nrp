import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/client.dart';
import '../../models/project.dart';
import '../../models/project_client.dart';

import '../../services/clients/clients_service.dart';
import '../../services/clients/mock_clients.dart';

@Component(
  selector: 'clients',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    '../../styles/styles.css',
    '../../styles/clients_component.css',
  ],
  templateUrl: 'clients_active_component.html',
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
    const ClassProvider(ClientsService, useClass: MockClients),
  ],
)
class ClientsComponent implements OnInit {
  final ClientsService clientsService;

  ClientsComponent(this.clientsService);

  @Input()

  ProjectClient selected;
  List<ProjectClient> activeClients;
  bool openClientPanel = true;
  Project currentProject;
  List<Project> projectsClient; //Proyectos en los que está un cliente

  @override
  void ngOnInit() async {
    activeClients = await clientsService.getActiveClients(currentProject);

  }

  void onSelect(ProjectClient activeClient) {
    openClientPanel = true;
    selected = activeClient;
    getProjectsFromClient(activeClient.client);
  }

  //Añadir cliente a un proyecto
  void addClientToProject(){
    if (selected == null) return;
    Future<bool> b = clientsService.addClientToProject(selected.client, currentProject);

  }

  void getProjectsFromClient(Client client){

    projectsClient = clientsService.getProjectsFromClients(client);
    
  }
  
}
