import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

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
    MaterialPersistentDrawerDirective,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialButtonComponent,
  ],
  providers: [const ClassProvider(ClientsService)],
)
class ClientsComponent {
  final ClientsService clientsService;

  Client selected;
  List<Client> clients = mockClients;

  ClientsComponent(this.clientsService);

  void onSelect(Client client) => selected = client;

  void createClient() async {
    await clientsService.createClient();
  }
}
