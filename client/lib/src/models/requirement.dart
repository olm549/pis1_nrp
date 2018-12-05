class Requirement {
  int id;
  String requirementID;
  String title;
  String description;

  Requirement(this.id, this.requirementID, this.title, this.description);

  factory Requirement.fromJson(Map<String, dynamic> requirement) {
    return Requirement(
      requirement.containsKey('id') ? requirement['id'] : null,
      requirement.containsKey('requirementID')
          ? requirement['requirementID']
          : null,
      requirement.containsKey('title') ? requirement['title'] : null,
      requirement.containsKey('description')
          ? requirement['description']
          : null,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'requirementID': requirementID,
      'title': title,
      'description': description,
    };
  }
}
