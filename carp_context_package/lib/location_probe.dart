/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// The general location provider service.
location.Location locationService = location.Location();

// TODO - check for permissions...
//    PermissionStatus status = await SimplePermissions.requestPermission(Permission.AccessFineLocation);
//    bool granted = await SimplePermissions.checkPermission(Permission.AccessFineLocation);
//    print('>>> Permission, location : $granted');

// TODO - upgrade to newest version of location Flutter plugin.
// But - there are conflict w. the Weather plugin -- check w. Thomas...

/// Collects location information from the underlying OS's location API.
/// Is a [StreamProbe] that generates a [LocationDatum] every time location is changed.
class LocationProbe extends StreamProbe {
  Stream<LocationDatum> get stream => locationService
      .onLocationChanged()
      .asBroadcastStream()
      .map((location) => LocationDatum.fromLocationData(location));
}
