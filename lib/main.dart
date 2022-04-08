import 'package:flutter/material.dart';
import 'package:bloc_example/logic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: BlocProvider(
        create: (context) => PersonsBloc(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.read<PersonsBloc>().add(const LoadPersonsAction(
                        url: Persons.person1,
                      ));
                },
                child: const Text("Load json 1"),
              ),
              TextButton(
                onPressed: () {
                  //we can use context to travel up the widget tree and find
                  //bloc of type [PersonsBloc]
                  //Use .add() to add an event into the stream
                  context.read<PersonsBloc>().add(
                        const LoadPersonsAction(
                          url: Persons.person2,
                        ),
                      );
                },
                child: const Text("Load json 2"),
              )
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: (previous, current) =>
                  previous?.persons != current?.persons,
              builder: (context, state) {
                final persons = state?.persons;
                if (persons == null) {
                  return const SizedBox();
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: persons.length,
                      itemBuilder: (context, index) {
                        return Text(persons[index]!.name);
                      },
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}
