import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../models/client.dart';
import '../../models/project.dart';

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
  bool isEditing = true;

  Client selected;
  List<Client> clients;
  bool createClientPanel = false;
  String clientIdToAdd;
  String nameToAdd;
  String surnameToAdd;
  Project currentProject;

  @override
  void ngOnInit() async {
    clients = await clientsService.getActiveClients(currentProject);
  }

  void onSelect(Client client) {
    createClientPanel = false;
    selected = client;
  }

  //Añadir cliente a un proyecto
  void addToProject(){

  }
  
}
