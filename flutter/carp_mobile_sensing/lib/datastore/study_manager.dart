import 'dart:async';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

abstract class StudyManager {
  Future<Study> getStudy(String studyId);
}
