import '../model/user.dart';

import '../server.dart';

/// This controller handles user registration.
///
/// Users need a [User] account to manage all of their resources. The controller
/// has an [AuthServer] which adds new users to the authentication database.
class RegisterController extends QueryController<User> {
  RegisterController(ManagedContext context, this.authServer) : super(context);

  AuthServer authServer;

  /// Creates a new user.
  ///
  /// The [User] given in the body must contain the following data:
  ///
  /// * [User.username]
  /// * [User.password]
  ///
  /// Returns an [AuthToken] from the [authServer] for the new user.
  @Operation.post()
  Future<Response> createUser() async {
    if (query.values.username == null || query.values.password == null) {
      return Response.badRequest(
        body: {
          'errorMsg': 'Missing user or password',
        },
      );
    }

    final salt = AuthUtility.generateRandomSalt();
    final hashedPassword = authServer.hashPassword(query.values.password, salt);

    query.values.hashedPassword = hashedPassword;
    query.values.salt = salt;

    final insertedUser = await query.insert();

    return Response.ok(insertedUser);
  }
}
