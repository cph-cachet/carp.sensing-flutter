/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of mobile_sensing_app;

enum DeploymentMode {
  /// Use a local study protocol & deployment and store data locally in a file.
  LOCAL,

  /// Get the study deployment from CARP and store data back to CARP
  CARP,
}

class DeploymentManagerFactory {
  static final DeploymentManagerFactory _instance =
      DeploymentManagerFactory._();
  DeploymentManagerFactory._();
  factory DeploymentManagerFactory() => _instance;

  DeploymentManager getDeploymentManager(DeploymentMode mode) {
    switch (mode) {
      case DeploymentMode.LOCAL:
        return LocalDeploymentManager();
      case DeploymentMode.CARP:
        return CarpDeploymentManager();
      default:
        return LocalDeploymentManager();
    }
  }
}

abstract class DeploymentManager {
  DeploymentMode _deploymentMode;
  DeploymentMode get deploymentMode => _deploymentMode;

  @mustCallSuper
  DeploymentManager(this._deploymentMode);
  Future deploy();
}

class LocalDeploymentManager extends DeploymentManager {
  LocalDeploymentManager() : super(DeploymentMode.LOCAL);

  @override
  Future deploy() {
    // TODO: implement deploy
    throw UnimplementedError();
  }
}

class CarpDeploymentManager extends DeploymentManager {
  CarpDeploymentManager() : super(DeploymentMode.CARP);

  @override
  Future deploy() {
    // TODO: implement deploy
    throw UnimplementedError();
  }
}
