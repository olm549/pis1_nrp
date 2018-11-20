import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../model/client.dart';
import 'mock_clients.dart';

import './clients_service.dart';

@Component(
  selector: 'clients',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    'clients_component.css',
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
  providers: [const ClassProvider(ClientsService)],
)

class ClientsComponent {
  final ClientsService clientsService;

  @Input() bool isEditing = true;

  Client selected;
  List<Client> clients = mockClients;
  bool createClientPanel = false;
  String clientIdToAdd;
  String nameToAdd;
  String surnameToAdd;

  ClientsComponent(this.clientsService);

  void onSelect(Client client){
    createClientPanel = false;
    resetPanel();
    selected = client;
  }

  /*
  * Método para confirmar creación del cliente
  */
  void createClient() async {
    if(!comprobarClient()) return;

    Client createCl = await clientsService.createClient(clientIdToAdd,nameToAdd,surnameToAdd);

    if(createCl != null) createClientPanel = false;
  }

  /*
  * Método para abrir la ventana de edición de un cliente
  */
  void editClient() async{
    isEditing = true;
    createClientPanel = true;

    clientIdToAdd = selected.clientID;
    nameToAdd = selected.name;
    surnameToAdd = selected.surname;

    selected = null;
  }

  /*
  * Método para confirmar la edición de un cliente
  */
  void confirmEditClient(){
    if(!comprobarClient()) return;
  }

  /*
  * Método para eliminar un cliente
  */
  void deleteClient() async{
    Client deleted = await clientsService.deleteClient(selected.id);
  }

  /*
  * Método para abrir el panel de introducir formulario para agregar un cliente
  */
  void newClient(){
    if(createClientPanel == true) resetPanel();
    else createClientPanel = true;

    isEditing = false;

    if(selected!=null) selected = null;
  }

  /*
  * Resetear valores del panel
  */
  void resetPanel(){
    if(isEditing==false) createClientPanel = false;

    clientIdToAdd = "";
    nameToAdd = "";
    surnameToAdd = "";
  }

  /*
  * Método para cerrar la vista de editar cliente
  */
  void cancelEditClient(){
    resetPanel();
    isEditing = false;
    createClientPanel = false;
  }

  /*
  * Método para comprobar los valores del formulario
  */
  bool comprobarClient(){
    if(clientIdToAdd==null || nameToAdd == null || surnameToAdd == null) return false;
    if(clientIdToAdd=="" || nameToAdd == "" || surnameToAdd == "") return false;
    
    return true;
  }
}
