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
      projectRequirement['id'],
      projectRequirement['estimatedEffort'],
      projectRequirement['satisfaction'],
      Requirement.fromJson(projectRequirement[
          'requirement']), // TODO: Check nullability of requirement's values.
    );
  }

  Map toJson() {
    return {
      'id': id,
      'estimatedEffort': estimatedEffort,
      'satisfaction': satisfaction,
    };
  }
}
