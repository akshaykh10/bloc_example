//State
import 'package:bloc_example/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isFromCache;

  const FetchResult({
    required this.persons,
    required this.isFromCache,
  });

  @override
  String toString() {
    return "Result is fetched from CACHE: $isFromCache";
  }
}
