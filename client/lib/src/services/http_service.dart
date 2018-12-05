import 'dart:convert';

import 'package:angular/angular.dart';
import 'package:http/http.dart';

@Injectable()
class HttpService {
  static final _serverUrl = 'http://localhost:8888';
  static final _clientID = 'com.nrp.webapp';

  final basicAuth = Base64Encoder().convert('$_clientID:'.codeUnits);

  final Client _client;

  HttpService(this._client);

  String getUrl() {
    return _serverUrl;
  }

  Client getClient() {
    return _client;
  }

  Exception handleError(dynamic exception) {
    print(exception);
    return Exception('Server error; cause $exception');
  }

  dynamic extractData(Response resp) => jsonDecode(resp.body);
}
