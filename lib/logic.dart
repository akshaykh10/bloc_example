import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

enum Persons {
  person1,
  person2,
}

extension PersonUrl on Persons {
  String get url {
    switch (this) {
      case Persons.person1:
        return "http://192.168.1.2:5500/api/person1.json";
      case Persons.person2:
        return "http://192.168.1.2:5500/api/person2.json";
    }
  }
}

class Person {
  late final String name;
  late final int age;

  Person.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    age = json['age'] as int;
  }
}

/*
  [LoadAction] is an abstract class, lets understand why:
    1.abstract classes cannot be instantiated directly
    2.The subclasses that are extending,or implementing LoadAction will be 
    accepted by [PersonsBloc]
*/
abstract class LoadAction {
  const LoadAction();
}

//Event
@immutable
class LoadPersonsAction implements LoadAction {
  final Persons url; //person1 or person2

  const LoadPersonsAction({required this.url}) : super();
}

Future<Iterable<Person>> getPersons(String url) async {
  return await HttpClient()
      .getUrl(Uri.parse(
          url)) //sets up a request connection and sends a request object
      .then((req) => req
          .close()) //The request connection is closed after the response object is received
      .then((res) => res
          .transform(utf8.decoder)
          .join()) //The response is transformed to string
      .then((str) => json.decode(str)
          as List<dynamic>) //String is transformed into a list of json objects
      .then((list) => list.map(
          (e) => Person.fromJson(e))); //each json is mapped to [Person] object
}

//State
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

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<Persons, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      if (_cache.containsKey(event.url)) {
        final Iterable<Person> cacheValue = _cache[event.url]!;
        final result = FetchResult(persons: cacheValue, isFromCache: true);
        emit(result);
      } else {
        Iterable<Person> fetch = await getPersons(event.url.url);
        _cache[event.url] = fetch;
        final result = FetchResult(persons: fetch, isFromCache: false);
        emit(result);
      }
    });
  }
}
