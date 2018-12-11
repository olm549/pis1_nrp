import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/client.dart';

import '../../services/clients/clients_service.dart';
import '../../services/clients/http_clients.dart';

@Component(
  selector: 'clients',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    '../../styles/styles.css',
    '../../styles/clients_component.css',
  ],
  templateUrl: 'clients_component.html',
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
    const ClassProvider(ClientsService, useClass: HttpClients),
  ],
)
class ClientsComponent implements OnInit {
  final ClientsService clientsService;

  String errorMsg;

  ClientsComponent(this.clientsService);

  bool isEditing = false;
  bool isCreating = false;

  Client selected;
  List<Client> clients;

  bool createClientPanel = false;

  String clientIdToAdd;
  String nameToAdd;
  String surnameToAdd;

  @override
  void ngOnInit() async {
    clients = await clientsService.getClients();
  }

  void onSelect(Client client) {
    createClientPanel = false;
    isEditing = false;
    isCreating = false;

    selected = client;
  }

  // Método para confirmar creación del cliente
  void createClient() async {
    errorMsg = null;

    if (clientIdToAdd == null || nameToAdd == null || surnameToAdd == null) {
      errorMsg = 'Por favor, rellena todos los campos';

      return;
    }

    Client createdClient = await clientsService.createClient(
        clientIdToAdd, nameToAdd, surnameToAdd);

    if (createdClient != null) {
      createClientPanel = false;

      clients.add(createdClient);
    } else {
      errorMsg = 'El ID de ese cliente ya existe. Escoge otro.';
    }
  }

  // Método para abrir la ventana de edición de un cliente
  void editClient() async {
    errorMsg = null;
    isEditing = true;
    isCreating = false;
    createClientPanel = true;

    clientIdToAdd = selected.clientID;
    nameToAdd = selected.name;
    surnameToAdd = selected.surname;
  }

  // Método para confirmar la edición de un cliente
  void confirmEditClient() async {
    errorMsg = null;

    if (clientIdToAdd.isEmpty || nameToAdd.isEmpty || surnameToAdd.isEmpty) {
      errorMsg = 'Por favor, rellena todos los campos';

      return;
    }

    Client updatedClient = await clientsService.updateClient(
      selected.id,
      clientIdToAdd,
      nameToAdd,
      surnameToAdd,
    );

    if (updatedClient != null) {
      clients.remove(selected);
      clients.add(updatedClient);

      createClientPanel = false;
      isEditing = false;

      selected = updatedClient;
    } else {
      errorMsg = 'El ID de ese cliente ya existe. Escoge otro.';
    }
  }

  // Método para eliminar un cliente
  void deleteClient() async {
    bool deleted = await clientsService.deleteClient(selected.id);

    if (deleted) {
      clients.remove(selected);

      selected = null;
      isEditing = false;
      createClientPanel = false;
    }
  }

  // Método para abrir el panel de introducir formulario para agregar un cliente
  void newClient() {
    isEditing = false;
    isCreating = true;
    createClientPanel = true;

    if (selected != null) selected = null;

    clientIdToAdd = null;
    nameToAdd = null;
    surnameToAdd = null;
  }

  // Método para cerrar la vista de editar cliente
  void cancelEditClient() {
    isEditing = false;
    isCreating = false;
    createClientPanel = false;
  }

  void addToActiveProject() async {
    await clientsService.addClientToProject(selected.id);
  }
}
