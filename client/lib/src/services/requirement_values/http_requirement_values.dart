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

  Future<List<RequirementValue>> getValues(int requirementID) async {
    try {
      final response = await _httpService.getClient().get(
        '${_httpService.getUrl()}/projects/${_userService.getActiveProject().id}/requirements/$requirementID/values',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'Bearer ${_userService.getAccessToken()}',
        },
      );

      if (response.statusCode == 200) {
        final requirementValues = (_httpService.extractData(response) as List)
            .map((value) => RequirementValue.fromJson(value))
            .toList();

        return requirementValues;
      } else {
        return [];
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }

  Future<RequirementValue> updateValue(
    int requirementID,
    int clientID,
    double value,
  ) async {
    try {
      final response = await _httpService.getClient().put(
            '${_httpService.getUrl()}/projects/${_userService.getActiveProject().id}/requirements/$requirementID/values/$clientID',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader:
                  'Bearer ${_userService.getAccessToken()}',
            },
            body: jsonEncode({
              'value': value,
            }),
          );

      if (response.statusCode == 200) {
        final updatedValue =
            RequirementValue.fromJson(_httpService.extractData(response));

        return updatedValue;
      } else {
        return null;
      }
    } catch (e) {
      _httpService.handleError(e);
    }
  }
}
