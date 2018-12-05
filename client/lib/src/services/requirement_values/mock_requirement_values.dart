import 'package:angular/angular.dart';

import '../../models/requirement_value.dart';

import './requirement_values_service.dart';

@Injectable()
class MockRequirementValues extends RequirementValuesService {
  static final values = <RequirementValue>[];

  Future<List<RequirementValue>> getValues(int requirementID) async {
    return [];
  }

  Future<RequirementValue> updateValue(
    int requirementID,
    int clientID,
    double value,
  ) async {
    return null;
  }
}
