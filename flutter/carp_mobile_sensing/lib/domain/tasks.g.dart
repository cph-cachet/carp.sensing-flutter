// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(json['name'] as String)
    ..$ = json[r'$'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TaskToJson(Task instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  return val;
}

ParallelTask _$ParallelTaskFromJson(Map<String, dynamic> json) {
  return ParallelTask(json['name'] as String)
    ..$ = json[r'$'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ParallelTaskToJson(ParallelTask instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  return val;
}

SequentialTask _$SequentialTaskFromJson(Map<String, dynamic> json) {
  return SequentialTask(json['name'] as String)
    ..$ = json[r'$'] as String
    ..measures = (json['measures'] as List)
        ?.map((e) =>
            e == null ? null : Measure.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$SequentialTaskToJson(SequentialTask instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('name', instance.name);
  writeNotNull('measures', instance.measures);
  return val;
}
