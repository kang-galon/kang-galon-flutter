import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/services/user_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService = UserService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserBloc() : super(UserUninitialized());

  UserBloc.currentUser()
      : super(UserSuccess(name: FirebaseAuth.instance.currentUser.displayName));

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    try {
      // register
      if (event is UserRegister) {
        yield UserLoading();

        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: event.verificationId,
          smsCode: event.pin,
        );

        await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        var user = _firebaseAuth.currentUser;
        String jwtToken = await user.getIdToken();
        String uid = user.uid;

        await _userService.register(
            event.phoneNumber, event.name, uid, jwtToken);

        // reload profile user to avoid displayName null
        await user.reload();

        yield UserSuccess(name: user.displayName);
      }

      if (event is UserLogin) {
        yield UserLoading();

        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: event.verificationId,
          smsCode: event.pin,
        );

        await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        var user = _firebaseAuth.currentUser;

        yield UserSuccess(name: user.displayName);
      }

      if (event is UserIsExist) {
        yield UserLoading();

        bool isUserExist = await _userService.isUserExist(event.phoneNumber);
        yield isUserExist ? UserExist() : UserDoesntExist();
      }

      if (event is UserUpdate) {
        yield UserLoading();

        // update name on server
        await this._userService.updateProfile(event.name);

        // reload profile user to avoid displayName null
        await _firebaseAuth.currentUser.reload();

        yield UserSuccess(name: event.name);
      }
    } catch (e) {
      yield UserError();
    }
  }

  Future<void> sendOtp(
    String phoneNumber,
    Function(FirebaseAuthException) verificationFailed,
    Function(String verificationId, int forceResendingToken) codeSent,
  ) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationFailed: verificationFailed,
      codeSent: codeSent,
    );
  }

  void logOUt() {
    _firebaseAuth.signOut();
  }
}
