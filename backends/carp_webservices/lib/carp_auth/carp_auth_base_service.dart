part of 'carp_auth.dart';

/// An abstract base service class for all CARP Services:
///  * [CarpService]
///  * [DeploymentService]
///  * [ProtocolService]
///  * [ParticipationService]
abstract class CarpAuthBaseService {
  CarpAuthProperties? _authProperties;
  CarpUser? _currentUser;

  /// The CARP app associated with the CARP Web Service.
  /// Returns `null` if this service has not yet been configured via the
  /// [configure] method.
  CarpAuthProperties? get authProperties => _authProperties;

  /// Has this service been configured?
  bool get isConfigured => (_authProperties != null);

  /// Configure the this instance of a Carp Service.
  void configure(CarpAuthProperties authProperties) {
    _authProperties = authProperties;
  }

  /// Configure from another [service] which has already been configured
  /// and potentially authenticated.
  void configureFrom(CarpAuthBaseService service) {
    _currentUser = service._currentUser;
  }

  /// Gets the current user.
  /// Returns `null` if no user is authenticated.
  CarpUser? get currentUser => _currentUser;
}
