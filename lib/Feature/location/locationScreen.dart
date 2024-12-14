import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Model/location.dart';
import 'locationBloc.dart';
import 'locationState.dart';
import 'locationEvent.dart';
import '../asset/assetScreen.dart'; // Importer le fichier de l'écran des assets

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Charger les données dès que l'écran est affiché
    context.read<LocationBloc>().add(LoadLocations());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: LocationInput(),
          ),
        ],
      ),
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
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      child: ListTile(
        title: Text(location.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(location.description),
        onTap: () {
          // Naviguer vers AssetScreen avec les assets de cette location
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AssetScreen(assets: location.assets),
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
                  location.id,
                  nameController.text,
                  descriptionController.text,
                  location.assets,
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

class LocationInput extends StatelessWidget {
  const LocationInput({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    void _addLocation() {
      if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in both fields')),
        );
        return;
      }

      final newLocation = Location(
        DateTime.now().millisecondsSinceEpoch, // ID unique
        nameController.text,
        descriptionController.text,
        [], // Pas d'assets par défaut
      );

      context.read<LocationBloc>().add(AddLocation(newLocation));
      nameController.clear();
      descriptionController.clear();
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Location Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: _addLocation,
          ),
        ],
      ),
    );
  }
}
