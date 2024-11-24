class SubCategory {
  String type;
  String name;
  String description;
  String? filePath;

  SubCategory({
    required this.type,
    required this.name,
    required this.description,
    this.filePath,
  });
}
