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
      requirementValue['id'],
      requirementValue['value'],
      Requirement.fromJson(requirementValue['requirement']),
      Client.fromJson(requirementValue['client']),
    );
  }

  Map toJson() {
    return {
      'id': id,
      'value': value,
    };
  }
}
