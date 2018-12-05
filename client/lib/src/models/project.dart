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
      project.containsKey('id') ? project['id'] : null,
      project.containsKey('projectID') ? project['projectID'] : null,
      project.containsKey('name') ? project['name'] : null,
      project.containsKey('description') ? project['description'] : null,
      project.containsKey('effortLimit') ? project['effortLimit'] : null,
      project.containsKey('active') ? project['active'] : null,
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
