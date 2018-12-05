import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../models/client.dart';
import '../../models/project.dart';
import '../../models/project_client.dart';

import '../../services/project_clients/project_clients_service.dart';
import '../../services/project_clients/http_project_clients.dart';
import '../../services/project_clients/mock_project_clients.dart';

import '../../utils/routing.dart';

@Component(
  selector: 'clients',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    '../../styles/styles.css',
    '../../styles/clients_component.css',
  ],
  templateUrl: 'clients_active_component.html',
  directives: [
    routerDirectives,
    coreDirectives,
    formDirectives,
    MaterialPersistentDrawerDirective,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
    MaterialInputComponent,
    materialInputDirectives,
  ],
  exports: [Paths, Routes],
  providers: [
    const ClassProvider(ProjectClientsService, useClass: HttpProjectClients),
  ],
)
class ClientsComponent implements OnInit {
  final ProjectClientsService clientsService;

  ClientsComponent(this.clientsService);

  @Input()
  ProjectClient selected;
  List<ProjectClient> activeClients;
  bool openClientPanel = true;
  //List<Project> projectsClient; //Proyectos en los que está un cliente
  bool isEditing = false;
  String weightToAdd;

  @override
  void ngOnInit() async {
    activeClients = await clientsService.getProjectClients();
  }

  void onSelect(ProjectClient activeClient) {
    openClientPanel = true;
    selected = activeClient;
    //getProjectsFromClient(activeClient.client);
    isEditing = false;
  }

  //Devuelve los proyectos a los que pertenece un cliente
  void getProjectsFromClient(Client client) {
    //projectsClient = clientsService.getProjectsFromClients(client);
  }

  //Elimina un cliente activo
  void removeActiveClient() async {
    bool deletedActiveClient =
        await clientsService.deleteProjectClient(selected.id);
    if (deletedActiveClient) {
      activeClients.remove(selected);
      selected = null;
    }
  }

  //Abre el panel de editar peso
  void editWeight() {
    if (isEditing == false) {
      isEditing = true;
    } else {
      isEditing = false;
      weightToAdd = null;
    }
  }

  //Edita el peso de un cliente específico
  void confirmEditWeight() async {
    if (weightToAdd == null || weightToAdd == "") return;

    double weight;
    try {
      weight = double.parse(weightToAdd);
    } catch (e) {
      return;
    }
    ProjectClient updatedClient =
        await clientsService.updateProjectClient(selected.id, weight);

    if (updatedClient != null) {
      isEditing = false;
      selected.weight = weight;
    }
  }
}
