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
