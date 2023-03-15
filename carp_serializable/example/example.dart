import 'package:carp_serializable/carp_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'example.g.dart';

/// An example class.
@JsonSerializable()
class A extends Serializable {
  int? index;

  A() : super();

  @override
  Function get fromJsonFunction => _$AFromJson;

  factory A.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as A;

  @override
  Map<String, dynamic> toJson() => _$AToJson(this);
}

/// Another example class that inherits from A.
@JsonSerializable()
class B extends A {
  String? str;

  B() : super();

  // provide another type annotation for this class
  @override
  String get jsonType => 'dk.cachet.$runtimeType';

  @override
  Function get fromJsonFunction => _$BFromJson;
  factory B.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as B;
  @override
  Map<String, dynamic> toJson() => _$BToJson(this);
}

void main() {
  // remember to register the de-serialization functions in the JSON Factory
  FromJsonFactory().register(A());
  FromJsonFactory().register(B());

  A a = A();
  B b = B();
  a.index = 1;
  b.str = 'abc';

  print(toJsonString(a));
  print(toJsonString(b));

  A newA = A.fromJson(a.toJson());
  B newB = B.fromJson(b.toJson());

  print(toJsonString(newA.toJson()));
  print(toJsonString(newB.toJson()));
}
