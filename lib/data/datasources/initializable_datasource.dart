import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

// ignore: one_member_abstracts
abstract class InitDatasource {
  /// Initializes the datasource with the sessionId, used for authentication.
  /// Additionally pass the function used for creating OdooClient instances.
  /// This allows the developer to inject function that creates mocks and
  /// allows for easier testing.
  Future<void> initDatasource(
    String sessionId,
    OdooClient Function(String url, OdooSession session)? function,
    void Function(UserDetailsState) updateUserDetailsState,
  );
}
