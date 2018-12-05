import './requirement.dart';

class ProjectRequirement {
  int id;
  double estimatedEffort;
  double satisfaction;
  Requirement requirement;

  ProjectRequirement(
    this.id,
    this.estimatedEffort,
    this.satisfaction,
    this.requirement,
  );

  factory ProjectRequirement.fromJson(Map<String, dynamic> projectRequirement) {
    return ProjectRequirement(
      projectRequirement.containsKey('id') ? projectRequirement['id'] : null,
      projectRequirement.containsKey('estimatedEffort')
          ? projectRequirement['estimatedEffort']
          : null,
      projectRequirement.containsKey('satisfaction')
          ? projectRequirement['satisfaction']
          : null,
      projectRequirement.containsKey('requirement')
          ? Requirement.fromJson(projectRequirement['requirement'])
          : null,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'estimatedEffort': estimatedEffort,
      'satisfaction': satisfaction,
      'requirement': requirement.toJson(),
    };
  }
}
