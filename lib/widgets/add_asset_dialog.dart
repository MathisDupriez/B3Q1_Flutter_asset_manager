import 'package:flutter/material.dart';
import '../models/asset.dart';

void showAddAssetDialog(BuildContext context, List<Asset> assets, Function setState) {
  final TextEditingController newAssetController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[850],
        title: const Text('Add New Asset', style: TextStyle(color: Colors.tealAccent)),
        content: TextField(
          controller: newAssetController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter asset name',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (newAssetController.text.isNotEmpty) {
                setState(() {
                  assets.add(Asset(name: newAssetController.text, subCategories: []));
                });
                newAssetController.clear();
              }
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: Colors.tealAccent)),
          ),
          TextButton(
            onPressed: () {
              newAssetController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      );
    },
  );
}
