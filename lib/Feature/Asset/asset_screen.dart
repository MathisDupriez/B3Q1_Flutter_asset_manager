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

  /// Boîte de dialogue pour ajouter un asset
  void _showAddAssetDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
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
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nom'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 10),
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
                      Asset newAsset;
                      switch (selectedAssetType) {
                        case 'AppAsset':
                          newAsset = AppAsset(
                            DateTime.now().millisecondsSinceEpoch,
                            nameController.text,
                            descriptionController.text,
                            'https://example.com/app', // URL fictive
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
                        default:
                          newAsset = FileAsset(
                            DateTime.now().millisecondsSinceEpoch,
                            nameController.text,
                            descriptionController.text,
                            'https://example.com/file.pdf', // URL fictive
                          );
                          break;
                      }
                      context.read<AssetBloc>().add(AddAssetEvent(newAsset));
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
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(asset.name),
        subtitle: Text(asset.description),
        trailing: onTap != null
            ? const Icon(Icons.arrow_forward)
            : null, 
        onTap: onTap,
      ),
    );
  }
}
