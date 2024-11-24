import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../models/sub_category.dart';
import '../widgets/add_asset_dialog.dart';
import '../widgets/add_sub_category_dialog.dart';

class AssetListScreen extends StatefulWidget {
  const AssetListScreen({super.key});

  @override
  _AssetListScreenState createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {
  List<Asset> assets = [
    Asset(
      name: 'Acer-Fedora',
      subCategories: [
        SubCategory(type: 'Application', name: 'VS Code', description: 'Code editor'),
        SubCategory(type: 'File', name: 'Config File', description: 'System configuration', filePath: '/etc/system/config.yaml'),
      ],
    ),
    // Ajoutez d'autres actifs ici
  ];

  TextEditingController searchController = TextEditingController();

  List<Asset> get filteredAssets {
    final query = searchController.text.toLowerCase();
    return assets.where((asset) {
      final inAssetName = asset.name.toLowerCase().contains(query);
      final inSubCategories = asset.subCategories.any((subCategory) =>
          subCategory.name.toLowerCase().contains(query) || subCategory.description.toLowerCase().contains(query));
      return inAssetName || inSubCategories;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Asset Management', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Search assets or subcategories...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.tealAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredAssets.length,
        itemBuilder: (context, index) {
          final asset = filteredAssets[index];
          return Card(
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 20.0),
              leading: const Icon(Icons.devices, color: Colors.tealAccent),
              title: Text(asset.name, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
              subtitle: Text('${asset.subCategories.length} items', style: Theme.of(context).textTheme.bodyMedium),
              children: [
                Column(
                  children: asset.subCategories.map((subCategory) {
                    return ListTile(
                      leading: Icon(
                        subCategory.type == 'File' ? Icons.insert_drive_file : Icons.apps,
                        color: subCategory.type == 'File' ? Colors.blue : Colors.green,
                      ),
                      title: Text(subCategory.name, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        subCategory.type == 'File'
                            ? 'Path: ${subCategory.filePath}\nDescription: ${subCategory.description}'
                            : 'Description: ${subCategory.description}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            asset.subCategories.remove(subCategory);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        showAddSubCategoryDialog(context, index, assets, setState);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Subcategory'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddAssetDialog(context, assets, setState);
        },
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
