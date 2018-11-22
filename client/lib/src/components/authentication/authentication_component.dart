import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../utils/routing.dart';

import '../../services/authentication/authentication_service.dart';
import '../../services/authentication/mock_authentication.dart';

@Component(
  selector: 'auth',
  styleUrls: const ['authentication_component.css'],
  templateUrl: 'authentication_component.html',
  directives: [
    coreDirectives,
    formDirectives,
    MaterialInputComponent,
    MaterialButtonComponent,
  ],
  providers: [
    const ClassProvider(AuthenticationService, useClass: MockAuthentication),
  ],
)
class AuthenticationComponent {
  final AuthenticationService authService;
  final Router router;

  AuthenticationComponent(this.authService, this.router);

  String signInEmail = "hola@test.com";
  String signInPassword = "asd";

  String signUpEmail;
  String signUpPassword;
  String signUpPassword2;

  void signIn() async {
    bool succesful = await authService.signIn(signInEmail, signInPassword);

    if (succesful) {
      router.navigateByUrl(Paths.projects.toUrl());
    }
  }

  void signUp() async {
    if (signUpPassword == signUpPassword2) {
      await authService.signUp(signUpEmail, signUpPassword);
    }
  }
}
