import 'package:flutter_bloc/flutter_bloc.dart';
import 'authEvent.dart';
import 'authState.dart';
import '../../Model/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const LoggedOut()) {
    // Gestion de l'événement LoginEvent
    on<LoginEvent>((event, emit) async {
      // L'utilisateur est en train de se connecter
      emit(const LoggingIn());

      await Future.delayed(const Duration(seconds: 2)); // Simuler un délai de connexion

      if (event.email == "admin@admin.com" && event.password == "admin") {
        // Connexion réussie
        emit(LoggedIn(User(event.email, event.password)));
      } else {
        // Erreur de connexion
        emit(LoginError("Email ou mot de passe incorrect"));
      }
    });

    // Gestion de l'événement LogoutEvent
    on<LogoutEvent>((event, emit) {
      // Déconnexion
      emit(const LoggedOut());
    });
  }
}
