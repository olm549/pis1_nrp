class Requirement {
  int id;
  String requirementID;
  String title;
  String description;

  Requirement(this.id, this.requirementID, this.title, this.description);

  factory Requirement.fromJson(Map<String, dynamic> requirement) {
    return Requirement(
      requirement['id'],
      requirement['requirementID'],
      requirement['title'],
      requirement['description'],
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
