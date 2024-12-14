import 'package:b3q1_flutter_project_asset_manager/Feature/auth/authScreen.dart';
import 'package:b3q1_flutter_project_asset_manager/Repositories/locationRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Feature/auth/authBloc.dart';
import 'Feature/auth/authState.dart';
import 'Feature/location/locationScreen.dart';
import 'Feature/location/locationBloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    LocationRepository locationRepository = LocationRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(),
        ),
        BlocProvider(
          create: (_) => LocationBloc(locationRepository),
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
