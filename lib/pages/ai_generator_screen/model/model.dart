class ItemModel {
  final String imagePath;
  final String title;
  final int order;
  final int id;
  ItemModel(
      {required this.imagePath,
      required this.title,
      required this.order,
      required this.id});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      imagePath: json['image'],
      title: json['title'],
      order: json['order'] ?? 0,
      id: json['id'], // Provide a default value if 'order' is not present
    );
  }
}
