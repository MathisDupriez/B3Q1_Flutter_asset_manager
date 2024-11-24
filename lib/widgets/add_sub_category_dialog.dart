import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../models/sub_category.dart';

void showAddSubCategoryDialog(BuildContext context, int assetIndex, List<Asset> assets, Function setState) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController filePathController = TextEditingController();
  String selectedType = 'Application';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[850],
        title: const Text('Add Application or File', style: TextStyle(color: Colors.tealAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              dropdownColor: Colors.grey[850],
              items: ['Application', 'File']
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedType = value!;
              },
              value: selectedType,
            ),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter name',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter description',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (selectedType == 'File')
              TextField(
                controller: filePathController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter file path',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  assets[assetIndex].subCategories.add(SubCategory(
                    type: selectedType,
                    name: nameController.text,
                    description: descriptionController.text,
                    filePath: selectedType == 'File' ? filePathController.text : null,
                  ));
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: Colors.tealAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      );
    },
  );
}
