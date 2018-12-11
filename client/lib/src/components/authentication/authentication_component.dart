import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../utils/routing.dart';

import '../../services/authentication/authentication_service.dart';
import '../../services/authentication/http_authentication.dart';

@Component(
  selector: 'auth',
  styleUrls: const [
    '../../styles/styles.css',
    '../../styles/authentication_component.css',
  ],
  templateUrl: 'authentication_component.html',
  directives: [
    coreDirectives,
    formDirectives,
    MaterialInputComponent,
    MaterialButtonComponent,
    materialInputDirectives,
  ],
  providers: [
    const ClassProvider(AuthenticationService, useClass: HttpAuthentication),
  ],
)
class AuthenticationComponent {
  final AuthenticationService authService;
  final Router router;

  AuthenticationComponent(this.authService, this.router);

  String signInErrorMsg;
  String signUpErrorMsg;

  String signUpSuccessMsg;

  String signInEmail = '';
  String signInPassword = '';

  String signUpEmail = '';
  String signUpPassword = '';
  String signUpPassword2 = '';

  void signIn() async {
    signInErrorMsg = null;
    signUpErrorMsg = null;

    signUpSuccessMsg = null;

    if (signInEmail.isEmpty || signInPassword.isEmpty) {
      signInErrorMsg = 'Por favor, rellena todos los campos';

      return;
    }

    bool succesful = await authService.signIn(signInEmail, signInPassword);

    if (succesful) {
      router.navigateByUrl(Paths.projects.toUrl());
    } else {
      signInErrorMsg = 'Los datos introducidos no son correctos';
    }
  }

  void signUp() async {
    signInErrorMsg = null;
    signUpErrorMsg = null;

    signUpSuccessMsg = null;

    if (signUpEmail.isEmpty ||
        signUpPassword.isEmpty ||
        signUpPassword2.isEmpty) {
      signUpErrorMsg = 'Por favor, rellena todos los campos';

      return;
    }

    if (signUpPassword == signUpPassword2) {
      bool succesful = await authService.signUp(signUpEmail, signUpPassword);

      if (succesful) {
        signUpSuccessMsg = 'Registro correcto';
      } else {
        signUpErrorMsg = 'El email introducido ya está registrado';
      }
    } else {
      signUpErrorMsg = 'Las contraseñas introducidas no coinciden';
    }
  }
}
