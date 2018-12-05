class Client {
  int id;
  String clientID;
  String name;
  String surname;

  Client(this.id, this.clientID, this.name, this.surname);

  factory Client.fromJson(Map<String, dynamic> client) {
    return Client(
      client.containsKey('id') ? client['id'] : null,
      client.containsKey('clientID') ? client['clientID'] : null,
      client.containsKey('name') ? client['name'] : null,
      client.containsKey('surname') ? client['surname'] : null,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'clientID': clientID,
      'name': name,
      'surname': surname,
    };
  }
}
