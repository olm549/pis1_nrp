import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:angular/angular.dart';

import '../../models/requirement_value.dart';

import '../user/user_service.dart';
import '../http_service.dart';

import './requirement_values_service.dart';

@Injectable()
class HttpRequirementValues extends RequirementValuesService {
  final HttpService _httpService;
  final UserService _userService;

  HttpRequirementValues(this._httpService, this._userService);

  Future<List<RequirementValue>> getValues(int requirementID) async {}

  Future<RequirementValue> updateValue(
    int requirementID,
    int clientID,
    double value,
  ) async {}
}
