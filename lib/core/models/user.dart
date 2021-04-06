class User {
  String phoneNumber;
  String name;

  User({this.phoneNumber, this.name});
}

class UserSuccess extends User {
  UserSuccess({String name}) : super(name: name);
}

class UserError extends User {
  UserError() : super(name: '');
}

class UserLoading extends User {
  UserLoading() : super(name: '');
}
