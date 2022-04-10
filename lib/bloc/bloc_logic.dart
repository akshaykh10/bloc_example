import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_example/bloc/person.dart';
import 'package:bloc_example/bloc/state.dart';

import '../logic.dart';
import 'events.dart';

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
