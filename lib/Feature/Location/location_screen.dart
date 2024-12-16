import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Model/location.dart';
import 'location_bloc.dart';
import 'location_state.dart';
import 'location_event.dart';
import '../Asset/asset_screen.dart'; // Importer l'écran des assets
import '../Asset/asset_bloc.dart'; // Importer le bloc des assets
import '../Asset/asset_event.dart'; // Importer les événements des assets
import '../Auth/auth_bloc.dart'; // Importer votre bloc d'authentification
import '../Auth/auth_event.dart'; // Importer les événements de l'authentification

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Charger les données dès que l'écran est affiché
    context.read<LocationBloc>().add(LoadLocations());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 6.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Déclenche l'événement de déconnexion dans le bloc d'authentification
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is LocationLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is LocationUpdated) {
                  final locations = state.locations;
                  if(state.locations.isEmpty) {
                    return const Center(
                      child: Text(
                        'No locations available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      final location = locations[index];
                      return LocationCard(location: location);
                    },
                  );
                }

                return const Center(
                  child: Text(
                    'No locations available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLocationDialog(context);  // Ouvre la popup pour ajouter une location
        },
        backgroundColor: Colors.blueAccent,
        tooltip: 'Add Location',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Fonction pour afficher le popup de la nouvelle Location
  void _showAddLocationDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Location Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in both fields')),
                  );
                  return;
                }

                final newLocation = Location(
                  name: nameController.text,
                  description: descriptionController.text,
                  assets: [], // Pas d'assets par défaut
                );

                context.read<LocationBloc>().add(AddLocation(newLocation));
                nameController.clear();
                descriptionController.clear();
                Navigator.of(context).pop();  // Fermer le dialog après ajout
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class LocationCard extends StatelessWidget {
  final Location location;

  const LocationCard({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          location.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          location.description,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        onTap: () {
          context.read<AssetBloc>().add(SetAssetEvent(location.assets, location));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AssetScreen(),
            ),
          );
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _showEditLocationDialog(context, location);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<LocationBloc>().add(RemoveLocation(location.id));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditLocationDialog(BuildContext context, Location location) {
    final nameController = TextEditingController(text: location.name);
    final descriptionController = TextEditingController(text: location.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedLocation = Location(
                  id: location.id,
                  name: nameController.text,
                  description: descriptionController.text,
                  assets: location.assets,
                );
                context.read<LocationBloc>().add(UpdateLocation(updatedLocation));
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
