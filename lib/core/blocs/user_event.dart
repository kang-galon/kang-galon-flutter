import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  UserEvent();
}

class UserRegister extends UserEvent {
  final String phoneNumber;
  final String name;
  final String verificationId;
  final String pin;

  UserRegister({
    this.phoneNumber,
    this.name,
    this.verificationId,
    this.pin,
  });

  @override
  List<Object> get props => [phoneNumber, name, verificationId, pin];
}

class UserLogin extends UserEvent {
  final String pin;
  final String verificationId;

  UserLogin({this.pin, this.verificationId});

  @override
  List<Object> get props => [pin, verificationId];
}

class UserUpdate extends UserEvent {
  final String name;

  UserUpdate({this.name});

  @override
  List<Object> get props => [name];
}

class UserIsExist extends UserEvent {
  final String phoneNumber;

  UserIsExist({this.phoneNumber});

  @override
  List<Object> get props => [];
}
