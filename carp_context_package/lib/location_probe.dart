/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

// TODO - check for permissions...
//    PermissionStatus status = await SimplePermissions.requestPermission(Permission.AccessFineLocation);
//    bool granted = await SimplePermissions.checkPermission(Permission.AccessFineLocation);
//    print('>>> Permission, location : $granted');

// TODO - upgrade to newest version of location Flutter plugin.

/// Collects location information from the underlying OS's location API.
/// Is a [StreamProbe] that generates a [LocationDatum] every time location is changed.
class LocationProbe extends StreamProbe {
  Stream<LocationDatum> get stream =>
      location.Location().onLocationChanged().map((event) => LocationDatum.fromMap(event));
}
