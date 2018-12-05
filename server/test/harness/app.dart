import 'package:server/server.dart';
import 'package:server/model/user.dart';
import 'package:aqueduct_test/aqueduct_test.dart';

export 'package:server/server.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';

/// A testing harness for server.
///
/// A harness for testing an aqueduct application. Example test file:
///
///         void main() {
///           Harness harness = Harness()..install();
///
///           test("GET /path returns 200", () async {
///             final response = await harness.agent.get("/path");
///             expectResponse(response, 200);
///           });
///         }
///
class Harness extends TestHarness<NrpServerChannel>
    with TestHarnessAuthMixin<NrpServerChannel>, TestHarnessORMMixin {
  @override
  ManagedContext get context => channel.context;

  @override
  AuthServer get authServer => channel.authServer;

  Agent publicAgent;

  Agent userAgent;

  User testUser;

  @override
  Future onSetUp() async {
    await resetData();

    publicAgent = await addClient('com.nrp.test');

    testUser = User()
      ..username = 'user@test.com'
      ..password = 'foobar123';

    userAgent = await registerUser(testUser);
  }

  @override
  Future onTearDown() async {}

  @override
  Future seed() async {
    // restore any static data. called by resetData.
  }

  Future<Agent> registerUser(User user, {Agent withClient}) async {
    withClient ??= publicAgent;

    await withClient.post(
      '/register',
      body: {
        'username': user.username,
        'password': user.password,
      },
    );

    return loginUser(withClient, user.username, user.password);
  }
}
