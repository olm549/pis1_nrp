import 'dart:async';

import '../../models/requirement_value.dart';

abstract class RequirementValuesService {
  Future<List<RequirementValue>> getValues(int requirementID);

  Future<RequirementValue> updateValue(
    int requirementID,
    int clientID,
    double value,
  );
}
