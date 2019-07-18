/// A library for collecting data from apps on the phone.
library apps;

import 'package:json_annotation/json_annotation.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:async';
import 'package:app_usage/app_usage.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'apps_datum.dart';
part 'app_probes.dart';
part 'apps_package.dart';
part 'apps.g.dart';

/// Specify the configuration on how to collect a list of apps usage on the device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AppUsageMeasure extends Measure {
  /// The duration back in time to collect the list. In milliseconds (ms).
  ///
  /// For example, if collecting one hour of app usage, duration = 60 * 60 * 1000 ms (which is the default value).
  int duration;

  AppUsageMeasure(MeasureType type, {name, enabled, this.duration = 60 * 60 * 1000})
      : super(type, name: name, enabled: enabled);

  static Function get fromJsonFunction => _$AppUsageMeasureFromJson;
  factory AppUsageMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$AppUsageMeasureToJson(this);

  String toString() => super.toString() + ', duration: $duration';
}
