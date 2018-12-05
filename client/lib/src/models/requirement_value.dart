import './client.dart';
import './requirement.dart';

class RequirementValue {
  int id;
  double value;
  Requirement requirement;
  Client client;

  RequirementValue(this.id, this.value, this.requirement, this.client);

  factory RequirementValue.fromJson(Map<String, dynamic> requirementValue) {
    return RequirementValue(
      requirementValue.containsKey('id') ? requirementValue['id'] : null,
      requirementValue.containsKey('value') ? requirementValue['value'] : null,
      requirementValue.containsKey('requirement')
          ? Requirement.fromJson(requirementValue['requirement'])
          : null,
      requirementValue.containsKey('client')
          ? Client.fromJson(requirementValue['client'])
          : null,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'value': value,
      'requirement': requirement.toJson(),
      'client': client.toJson(),
    };
  }
}
