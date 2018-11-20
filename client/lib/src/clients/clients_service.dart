import 'dart:async';

import 'package:angular/angular.dart';

import '../model/client.dart';

@Injectable()
class ClientsService {
  Future<List<Client>> getClients() async => null;

  Future<Client> createClient(String clientId, String clientName, String clientSurname) async => null;

  Future<Client> deleteClient(int clientId) async => null;
}
