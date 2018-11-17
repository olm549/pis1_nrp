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
  bool showIdNull, showNameNull, showSurnameNull = false;
  

  ClientsComponent(this.clientsService);

  void onSelect(Client client){
    createClientPanel = false;
    resetPanel();
    selected = client;
  }

  void createClient() async {

    if(clientIdToAdd==null || clientIdToAdd == "" ){
      showIdNull = true;
    }else{
      showIdNull = false;
    }
    
    if(nameToAdd == null || nameToAdd == "" ){
      showNameNull = true;
    }else{
      showNameNull = false;
    }
    
    if(surnameToAdd == null || surnameToAdd == "" ){
      showSurnameNull = true;
    }else{
      showSurnameNull = false;
    }

    if(clientIdToAdd==null || nameToAdd == null || surnameToAdd == null) return;

    print("clientIdToAdd = "+clientIdToAdd);
    print("name = "+nameToAdd);
    print("surname = "+surnameToAdd);

    Client createCl = await clientsService.createClient(clientIdToAdd,nameToAdd,surnameToAdd);
    if(createCl != null) createClientPanel = false;
    
    
  }

  void editClient() async{

  }

  void newClient(){
    isEditing = false;
    if(createClientPanel == true) resetPanel();
    else createClientPanel = true;
    if(selected!=null) selected = null;
    
  }

  void resetPanel(){
    createClientPanel = false;
    clientIdToAdd = "";
    nameToAdd = "";
    surnameToAdd = "";
    showIdNull = false;
    showNameNull = false;
    showSurnameNull = false;
  }
}
