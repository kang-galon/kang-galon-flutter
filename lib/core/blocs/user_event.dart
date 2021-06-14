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
    required this.phoneNumber,
    required this.name,
    required this.verificationId,
    required this.pin,
  });

  @override
  List<Object> get props => [phoneNumber, name, verificationId, pin];
}

class UserLogin extends UserEvent {
  final String pin;
  final String verificationId;

  UserLogin({required this.pin, required this.verificationId});

  @override
  List<Object> get props => [pin, verificationId];
}

class UserUpdate extends UserEvent {
  final String name;

  UserUpdate({required this.name});

  @override
  List<Object> get props => [name];
}

class UserIsExist extends UserEvent {
  final String phoneNumber;

  UserIsExist({required this.phoneNumber});

  @override
  List<Object> get props => [];
}
