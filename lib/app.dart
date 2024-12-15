import 'package:b3q1_flutter_project_asset_manager/Feature/Auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Feature/Auth/auth_bloc.dart';
import 'Feature/Auth/auth_state.dart';
import 'Feature/Location/location_screen.dart';
import 'Feature/Location/location_bloc.dart';
import 'Feature/Asset/asset_bloc.dart'; 

import 'Repositories/location_repository.dart';
import 'Repositories/auth_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    LocationRepository locationRepository = LocationRepository();
    AuthRepository authRepository = AuthRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authRepository : authRepository),
        ),
        BlocProvider(
          create: (_) => LocationBloc(locationRepository),
        ),
        BlocProvider(
          create: (_) => AssetBloc(locationRepository: locationRepository), // Ajouter le bloc des assets
        ),
      ],
      child: MaterialApp(
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is LoggedIn) {
              // Si l'utilisateur est authentifié, afficher le LocationScreen
              return const LocationScreen();
            } else {
              // Si l'utilisateur n'est pas authentifié, afficher le AuthScreen
              return const AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
