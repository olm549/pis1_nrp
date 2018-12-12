import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:angular/angular.dart';

import '../../models/project.dart';

import '../user/user_service.dart';
import '../http_service.dart';

import './plan_service.dart';

@Injectable()
class HttpPlan extends PlanService {
  final HttpService _httpService;
  final UserService _userService;

  HttpPlan(this._httpService, this._userService);

  Project getActiveProject() {
    return _userService.getActiveProject();
  }
}
