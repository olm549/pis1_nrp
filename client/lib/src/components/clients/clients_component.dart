import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/client.dart';

import '../../services/clients/clients_service.dart';
import '../../services/clients/mock_clients.dart';

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
    const ClassProvider(ClientsService, useClass: MockClients),
  ],
)
class ClientsComponent implements OnInit {
  final ClientsService clientsService;

  ClientsComponent(this.clientsService);

  @Input()
  bool isEditing = true;
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
    resetPanel();
    selected = client;
  }

  // Método para confirmar creación del cliente
  void createClient() async {
    if (!comprobarClient()) return;

    Client createdClient = await clientsService.createClient(
        clientIdToAdd, nameToAdd, surnameToAdd);

    if (createdClient != null) {
      clients.add(createdClient);

      createClientPanel = false;
    }
  }

  // Método para abrir la ventana de edición de un cliente
  void editClient() async {
    isEditing = true;
    createClientPanel = true;

    clientIdToAdd = selected.clientID;
    nameToAdd = selected.name;
    surnameToAdd = selected.surname;

    //selected = null;
  }

  // Método para confirmar la edición de un cliente
  void confirmEditClient() async {
    if (!comprobarClient()) return;

    Client updatedClient = await clientsService.updateClient(
      selected.id,
      selected.clientID,
      selected.name,
      selected.surname,
    );

    // TODO: Revisar implementación.
    clients.remove(selected);

    isEditing = false;
    createClientPanel = false;

    clients.add(updatedClient);
  }

  // Método para eliminar un cliente
  void deleteClient() async {
    bool deleted = await clientsService.deleteClient(selected.id);

    if (deleted) {
      clients.remove(selected);

      selected = null;
    }
  }

  // Método para abrir el panel de introducir formulario para agregar un cliente
  void newClient() {
    if (createClientPanel == true)
      resetPanel();
    else
      createClientPanel = true;

    isCreating = true;

    if (selected != null) selected = null;
  }

  // Resetear valores del panel
  void resetPanel() {
    if (isEditing == false) createClientPanel = false;

    clientIdToAdd = "";
    nameToAdd = "";
    surnameToAdd = "";
  }

  // Método para cerrar la vista de editar cliente
  void cancelEditClient() {
    resetPanel();
    isEditing = false;
    createClientPanel = false;
  }

  // Método para comprobar los valores del formulario
  bool comprobarClient() {
    if (clientIdToAdd == null || nameToAdd == null || surnameToAdd == null)
      return false;
    if (clientIdToAdd == "" || nameToAdd == "" || surnameToAdd == "")
      return false;

    return true;
  }
}
