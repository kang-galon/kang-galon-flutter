import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/models/user.dart' as My;
import 'package:kang_galon/core/services/user_service.dart';

class UserBloc extends Bloc<My.User, My.User> {
  final UserService _userService = UserService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserBloc() : super(My.UserUninitialized());

  UserBloc.register(My.User user) : super(user);

  UserBloc.currentUser()
      : super(My.User(name: FirebaseAuth.instance.currentUser.displayName));

  @override
  Stream<My.User> mapEventToState(My.User event) async* {
    yield My.UserLoading();

    try {
      // register
      if (event is My.UserRegister) {
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: event.verificationId,
          smsCode: event.pin,
        );

        await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        var user = FirebaseAuth.instance.currentUser;
        String jwtToken = await user.getIdToken();
        String uid = user.uid;

        await _userService.register(
            event.phoneNumber, event.name, uid, jwtToken);

        // reload profile user to avoid displayName null
        await _firebaseAuth.currentUser.reload();

        yield My.UserSuccess(name: user.displayName);
      } else if (event is My.UserLogin) {
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: event.verificationId,
          smsCode: event.pin,
        );

        await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        var user = FirebaseAuth.instance.currentUser;

        yield My.UserSuccess(name: user.displayName);
      } else {
        // update name on server
        await this._userService.updateProfile(event.name);

        // reload profile user to avoid displayName null
        await _firebaseAuth.currentUser.reload();

        yield My.UserSuccess(name: event.name);
      }
    } catch (e) {
      yield My.UserError();
    }
  }
}
