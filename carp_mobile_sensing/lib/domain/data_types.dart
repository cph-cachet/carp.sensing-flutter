/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// Contains CAMS data type definitions similar to CARP Core [CarpDataTypes].
class CAMSDataType {
  static const String FILE_TYPE_NAME = '${CarpDataTypes.CARP_NAMESPACE}.file';

  CAMSDataType() {
    CarpDataTypes().add([
      DataTypeMetaData(
        type: FILE_TYPE_NAME,
        displayName: "File",
        timeType: DataTimeType.POINT,
      )
    ]);
  }
}
