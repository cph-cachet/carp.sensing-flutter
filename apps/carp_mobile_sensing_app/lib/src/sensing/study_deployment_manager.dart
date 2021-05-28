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

  /// Use the CARP production server to get the study deployment and store data.
  CARP_PRODUCTION,

  /// Use the CARP staging server to get the study deployment and store data.
  CARP_STAGING,
}
