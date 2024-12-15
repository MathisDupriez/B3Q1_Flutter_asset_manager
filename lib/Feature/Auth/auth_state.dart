import '../../Model/user.dart';

abstract class AuthState {
  const AuthState();
}

class LoggingIn extends AuthState {
  const LoggingIn();
}

class LoggedOut extends AuthState {
  const LoggedOut();
}

class LoggedIn extends AuthState {
  final User user;
  LoggedIn(this.user);
}

class LoginError extends AuthState {
  final String error;
  LoginError(this.error);
}