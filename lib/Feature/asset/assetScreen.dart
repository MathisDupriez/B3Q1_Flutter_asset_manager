import 'package:flutter/material.dart';
import '../../Model/asset.dart';
import '../../Model/directory_asset.dart';
import '../../Model/file_asset.dart';
import '../../Model/app_asset.dart';

class AssetScreen extends StatelessWidget {
  final List<Asset> assets;

  const AssetScreen({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];

                // Si l'asset est un DirectoryAsset, afficher ses sous-assets
                if (asset is DirectoryAsset) {
                  return AssetCard(
                    asset: asset,
                    onTap: () {
                      // Naviguer vers un autre écran pour afficher les sous-assets
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssetScreen(assets: asset.assets),
                        ),
                      );
                    },
                  );
                } else {
                  // Afficher les autres types d'assets
                  return AssetCard(asset: asset);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddAssetDialog(context);
              },
              child: const Text('Ajouter un Asset'),
            ),
          ),
        ],
      ),
    );
  }

  /// Boîte de dialogue pour ajouter un nouvel Asset
  void _showAddAssetDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedAssetType = 'FileAsset'; // Par défaut, un FileAsset est sélectionné

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter un Asset'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Champ pour le nom
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                  ),
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
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Veuillez remplir tous les champs')),
                      );
                      return;
                    }

                    // Créer l'asset en fonction du type sélectionné
                    Asset newAsset;
                    switch (selectedAssetType) {
                      case 'AppAsset':
                        newAsset = AppAsset(
                          nameController.text,
                          descriptionController.text,
                          'https://example.com/app', // Lien fictif
                        );
                        break;
                      case 'DirectoryAsset':
                        newAsset = DirectoryAsset(
                          nameController.text,
                          descriptionController.text,
                          [],
                        );
                        break;
                      default:
                        newAsset = FileAsset(
                          nameController.text,
                          descriptionController.text,
                          'https://example.com/file.pdf', // Lien fictif
                        );
                        break;
                    }

                    // Ajouter l'asset et fermer la boîte de dialogue
                    assets.add(newAsset); // Attention : nécessite une liste modifiable
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
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
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(asset.name),
        subtitle: Text(asset.description),
        trailing: onTap != null
            ? const Icon(Icons.arrow_forward)
            : null, // Affiche la flèche si c'est un DirectoryAsset
        onTap: onTap,
      ),
    );
  }
}
