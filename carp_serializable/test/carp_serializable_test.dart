import 'package:carp_serializable/carp_serializable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:test/test.dart';

part 'carp_serializable_test.g.dart';

void main() {
  setUp(() {
    // remember to register the de-serialization functions in the JSON Factory
    FromJsonFactory().register(A());
    FromJsonFactory().register(B());
  });

  test('A & B -> JSON w. null value', () async {
    A a = A();
    B b = B();
    a.index = 1;
    b.str = 'abc';

    print(toJsonString(a));
    print(toJsonString(b));
  });

  test('A & B -> JSON', () async {
    A a = A();
    B b = B();
    a.index = 1;

    b.index = 2;
    b.str = 'abc';

    print(toJsonString(a));
    print(toJsonString(b));
  });

  test('JSON -> A & B', () async {
    A a = A();
    B b = B();
    a.index = 1;

    b.index = 2;
    b.str = 'abc';

    A newA = A.fromJson(a.toJson());
    B newB = B.fromJson(b.toJson());

    expect(newA, isNot(a));
    expect(newB, isNot(b));
    expect(newA.index, a.index);
    expect(newB.str, b.str);

    print(toJsonString(newA.toJson()));
    print(toJsonString(newB.toJson()));
  });

  test('UUID - version 4.0', () async {
    List<String> list = [];
    for (var i = 0; i < 5; i++) {
      list.add((UUID.v1));
      list.add((UUID.v1));
    }
    list.forEach(print);

    // check that all UUIDs are unique
    var unique = list.toSet().toList();
    expect(unique.length, list.length);
  });
}

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

@JsonSerializable()
class B extends A {
  String? str;

  B() : super();

  @override
  String get jsonType => 'dk.cachet.$runtimeType';

  @override
  Function get fromJsonFunction => _$BFromJson;
  factory B.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as B;
  @override
  Map<String, dynamic> toJson() => _$BToJson(this);
}
