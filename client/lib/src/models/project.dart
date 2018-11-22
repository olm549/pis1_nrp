class Project {
  int id;
  String projectID;
  String name;
  String description;
  double effortLimit;
  bool active;

  Project(
    this.id,
    this.projectID,
    this.name,
    this.description,
    this.effortLimit,
    this.active,
  );

  factory Project.fromJson(Map<String, dynamic> project) {
    return Project(
      project['id'],
      project['projectID'],
      project['name'],
      project['description'],
      project['effortLimit'],
      project['active'],
    );
  }

  Map toJson() {
    return {
      'id': id,
      'projectID': projectID,
      'name': name,
      'description': description,
      'effortLimit': effortLimit,
      'active': active,
    };
  }
}
