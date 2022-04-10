class Person {
  late final String name;
  late final int age;

  Person.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    age = json['age'] as int;
  }
}
