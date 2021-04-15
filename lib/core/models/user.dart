class User {
  String phoneNumber;
  String name;

  User({this.phoneNumber, this.name});
}

class UserUninitialized extends User {}

class UserRegister extends User {
  final String phoneNumber;
  final String name;
  final String verificationId;
  final String pin;

  UserRegister(this.phoneNumber, this.name, this.verificationId, this.pin);
}

class UserLogin extends User {
  final String pin;
  final String verificationId;

  UserLogin(this.pin, this.verificationId);
}

class UserSuccess extends User {
  UserSuccess({String name}) : super(name: name);
}

class UserError extends User {}

class UserLoading extends User {}
