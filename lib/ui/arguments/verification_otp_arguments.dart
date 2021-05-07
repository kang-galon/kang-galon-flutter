class VerificationOtpArguments {
  final String verificationId;
  final String phoneNumber;
  final String name;
  final bool isLogin;

  VerificationOtpArguments(
    this.verificationId,
    this.phoneNumber,
    this.name, {
    this.isLogin = false,
  });
}
