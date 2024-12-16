import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Model/asset.dart';
import '../../Model/directory_asset.dart';
import '../../Model/file_asset.dart';
import '../../Model/app_asset.dart';
import 'asset_bloc.dart';
import 'asset_event.dart';
import 'asset_state.dart';

class AssetScreen extends StatelessWidget {
  const AssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AssetBloc, AssetState>(
              builder: (context, state) {
                if (state is AssetInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AssetsLoaded) {
                  final assets = state.currentAssets;
                  return ListView.builder(
                    itemCount: assets.length,
                    itemBuilder: (context, index) {
                      final asset = assets[index];
                      if (asset is DirectoryAsset) {
                        return AssetCard(
                          asset: asset,
                          onTap: () {
                            // Ajouter des événements avant de naviguer vers AssetScreen
                            context.read<AssetBloc>().add(goDownEvent(asset.id)); // Action pour descendre
                            context.read<AssetBloc>().add(LoadAssetsEvent()); // Charger les assets

                            // Naviguer vers AssetScreen avec les assets de cette location
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AssetScreen(),
                              ),
                            ).then((_) {
                              context.read<AssetBloc>().add(goUpEvent()); // Action pour remonter
                              context.read<AssetBloc>().add(LoadAssetsEvent());
                            });
                          },
                        );
                      } else {
                        return AssetCard(asset: asset);
                      }
                    },
                  );
                } else {
                  return const Center(child: Text('Aucun asset disponible.'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAssetDialog(context);  // Ouvre la popup pour ajouter une location
        },
        backgroundColor: Colors.blueAccent,
        tooltip: 'Add Location',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Boîte de dialogue pour ajouter un asset
  void _showAddAssetDialog(BuildContext context) {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final pathController = TextEditingController();
  String selectedAssetType = 'FileAsset'; // Type par défaut

  showDialog(
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: BlocProvider.of<AssetBloc>(context), // Récupère le bloc depuis le parent
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter un Asset'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Champ pour le nom
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nom'),
                    ),
                    const SizedBox(height: 10),

                    // Champ pour la description
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 10),

                    // Dropdown pour sélectionner le type d'asset
                    DropdownButton<String>(
                      value: selectedAssetType,
                      items: const [
                        DropdownMenuItem(
                          value: 'FileAsset',
                          child: Text('Fichier (FileAsset)'),
                        ),
                        DropdownMenuItem(
                          value: 'AppAsset',
                          child: Text('Application (AppAsset)'),
                        ),
                        DropdownMenuItem(
                          value: 'DirectoryAsset',
                          child: Text('Dossier (DirectoryAsset)'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedAssetType = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // Champ pour le path (affiché uniquement si FileAsset ou AppAsset est sélectionné)
                    if (selectedAssetType != 'DirectoryAsset')
                      TextField(
                        controller: pathController,
                        decoration: const InputDecoration(labelText: 'Chemin (Path)'),
                      ),
                  ],
                ),
              ),
              actions: [
                // Bouton Annuler
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),

                // Bouton Ajouter
                ElevatedButton(
                  onPressed: () {
                    // Vérifie que les champs requis sont remplis
                    if (nameController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        (selectedAssetType != 'DirectoryAsset' && pathController.text.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Veuillez remplir tous les champs requis')),
                      );
                      return;
                    }

                    // Crée un nouvel asset en fonction du type sélectionné
                    Asset newAsset;
                    switch (selectedAssetType) {
                      case 'AppAsset':
                        newAsset = AppAsset(
                          DateTime.now().millisecondsSinceEpoch,
                          nameController.text,
                          descriptionController.text,
                          pathController.text, // Utilise le chemin fourni
                        );
                        break;
                      case 'DirectoryAsset':
                        newAsset = DirectoryAsset(
                          DateTime.now().millisecondsSinceEpoch,
                          nameController.text,
                          descriptionController.text,
                          [],
                        );
                        break;
                      default: // FileAsset
                        newAsset = FileAsset(
                          DateTime.now().millisecondsSinceEpoch,
                          nameController.text,
                          descriptionController.text,
                          pathController.text, // Utilise le chemin fourni
                        );
                        break;
                    }

                    // Ajoute l'asset via le bloc
                    context.read<AssetBloc>().add(AddAssetEvent(newAsset));

                    // Ferme la boîte de dialogue
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

}



class AssetCard extends StatelessWidget {
  final Asset asset;
  final VoidCallback? onTap;

  const AssetCard({super.key, required this.asset, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Définir les styles pour réutilisation
    const TextStyle titleStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    const TextStyle descriptionStyle = TextStyle(
      fontSize: 14.0,
      color: Colors.black54,
    );

    const TextStyle pathStyle = TextStyle(
      fontSize: 12.0,
      color: Colors.grey,
      overflow: TextOverflow.ellipsis,
    );

    // Déterminer l'icône selon le type d'asset
    IconData iconData;
    if (asset is DirectoryAsset) {
      iconData = Icons.folder;
    } else if (asset is AppAsset) {
      iconData = Icons.apps;
    } else {
      iconData = Icons.insert_drive_file;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      elevation: 4, // Ombrage légèrement plus prononcé
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Coins arrondis
      ),
      child: InkWell(
        onTap: onTap, // Ajouter une interaction tactile pour toute la carte
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Icône à gauche
              Icon(
                iconData,
                size: 40.0,
                color: asset is DirectoryAsset
                    ? Colors.amber
                    : (asset is AppAsset ? Colors.blue : Colors.grey),
              ),
              const SizedBox(width: 16.0),

              // Informations de l'asset
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      asset.name,
                      style: titleStyle,
                    ),
                    const SizedBox(height: 4.0),

                    // Description
                    Text(
                      asset.description,
                      style: descriptionStyle,
                    ),
                    if (asset is FileAsset || asset is AppAsset)
                      const SizedBox(height: 4.0),

                    // Chemin (affiché uniquement pour les fichiers et applications)
                    if (asset is FileAsset || asset is AppAsset)
                      Text(
                        (asset as dynamic).path, // Accès dynamique au chemin
                        style: pathStyle,
                      ),
                  ],
                ),
              ),

              // Boutons d'action (Update, Delete, et flèche si applicable)
              Row(
                children: [
                  // Bouton Update
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Colors.blue,
                    tooltip: "Modifier", // Accessibilité
                    onPressed: () {
                      // Logique pour modifier l'asset
                      _showEditAssetDialog(context, asset);
                    },
                  ),

                  // Bouton Delete
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    tooltip: "Supprimer", // Accessibilité
                    onPressed: () {
                      context
                          .read<AssetBloc>()
                          .add(DeleteAssetEvent(asset.id));
                    },
                  ),

                  // Bouton flèche uniquement pour les DirectoryAsset
                  if (asset is DirectoryAsset && onTap != null)
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      color: Colors.grey,
                      tooltip: "Ouvrir le dossier", // Accessibilité
                      onPressed: onTap,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Logique pour afficher une boîte de dialogue lors de l'édition
  void _showEditAssetDialog(BuildContext context, Asset asset) {
    final nameController = TextEditingController(text: asset.name);
    final descriptionController = TextEditingController(text: asset.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier l\'asset'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Champ pour le nom
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              const SizedBox(height: 10),

              // Champ pour la description
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // MODIFIER ICI LEVENT DE MOFICIATION
                Navigator.of(context).pop();
              },
              child: const Text('Mettre à jour'),
            ),
          ],
        );
      },
    );
  }
}
