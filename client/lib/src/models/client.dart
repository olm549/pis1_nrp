class Client {
  int id;
  String clientID;
  String name;
  String surname;

  Client(this.id, this.clientID, this.name, this.surname);

  factory Client.fromJson(Map<String, dynamic> client) {
    return Client(
      client['id'],
      client['clientID'],
      client['name'],
      client['surname'],
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
