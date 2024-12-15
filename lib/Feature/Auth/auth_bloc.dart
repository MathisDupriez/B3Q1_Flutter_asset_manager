import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../Model/user.dart';
import '../../Repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository; // Dépôt pour gérer Firebase Auth

  AuthBloc({required this.authRepository}) : super(const LoggedOut()) {
    // Gestion de l'événement LoginEvent
    on<LoginEvent>((event, emit) async {
      // L'utilisateur est en train de se connecter
      emit(const LoggingIn());

      try {
        // Tentative de connexion via Firebase Auth
        final userCredential = await authRepository.signIn(
          email: event.email,
          password: event.password,
        );

        // Vérification explicite si user est non-null
        var firebaseUser = userCredential;
        if (firebaseUser != null) {
          // Connexion réussie, créer un utilisateur
          final user = User(
            firebaseUser.email ?? '',
            event.password, // Attention : ne jamais stocker de mot de passe en texte clair en production
          );
          emit(LoggedIn(user));
        } else {
          emit(LoginError("Échec de la connexion : utilisateur non trouvé."));
        }
      } catch (e) {
        // En cas d'erreur, émettre un état avec le message d'erreur
        emit(LoginError(e.toString()));
      }
    });

    // Gestion de l'événement LogoutEvent
    on<LogoutEvent>((event, emit) async {
      try {
        // Déconnexion via Firebase Auth
        await authRepository.signOut();
        emit(const LoggedOut());
      } catch (e) {
        emit(LoginError("Erreur lors de la déconnexion: ${e.toString()}"));
      }
    });
  }
}
