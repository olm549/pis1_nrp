import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../models/client.dart';
import '../../models/project.dart';
import '../../models/project_client.dart';

import '../../services/project_clients/project_clients_service.dart';
import '../../services/project_clients/http_project_clients.dart';

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
    materialNumberInputDirectives,
  ],
  exports: [Paths, Routes],
  providers: [
    const ClassProvider(ProjectClientsService, useClass: HttpProjectClients),
  ],
)
class ClientsComponent implements OnInit {
  final ProjectClientsService clientsService;

  ClientsComponent(this.clientsService);

  String errorMsg;

  bool isEditing = false;

  ProjectClient selected;
  List<ProjectClient> activeClients;

  double weightToAdd;

  @override
  void ngOnInit() async {
    activeClients = await clientsService.getProjectClients();
  }

  void onSelect(ProjectClient activeClient) {
    selected = activeClient;

    isEditing = false;
  }

  //Elimina un cliente activo
  void removeActiveClient() async {
    bool deleted = await clientsService.deleteProjectClient(selected.client.id);

    if (deleted) {
      activeClients.remove(selected);

      selected = null;
      isEditing = false;
    }
  }

  //Abre el panel de editar peso
  void editWeight() {
    errorMsg = null;
    isEditing = true;

    weightToAdd = selected.weight;
  }

  //Edita el peso de un cliente específico
  void confirmEditWeight() async {
    errorMsg = null;

    if (weightToAdd == null) {
      errorMsg = 'El peso no puede ser vacío';

      return;
    }

    ProjectClient updatedClient = await clientsService.updateProjectClient(
        selected.client.id, weightToAdd);

    if (updatedClient != null) {
      updatedClient.client = selected.client;

      activeClients.remove(selected);
      activeClients.add(updatedClient);

      isEditing = false;

      selected = updatedClient;
    }
  }

  void cancelEditWeight() {
    isEditing = false;
  }
}
