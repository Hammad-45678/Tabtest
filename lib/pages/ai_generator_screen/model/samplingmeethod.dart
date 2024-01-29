class SamplingMethodModel {
  final int id;
  final String title;
  final String descrption;
  SamplingMethodModel(
      {required this.id, required this.title, required this.descrption});

  factory SamplingMethodModel.fromJson(Map<String, dynamic> json) {
    return SamplingMethodModel(
      id: json['id'],
      title: json['title'],
      descrption: json['description'],
    );
  }
}
