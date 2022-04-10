import 'package:flutter/foundation.dart' show immutable;

import '../logic.dart';

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
