class ObjectRemoveModel {
  String status;
  String? message;
  Data? data;

  ObjectRemoveModel({required this.status, this.message, this.data});

  factory ObjectRemoveModel.fromJson(Map<String, dynamic> json) =>
      ObjectRemoveModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class Data {
  String? image;
  String? watermarkImage;

  Data({this.image, this.watermarkImage});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        image: json['image'],
        watermarkImage: json['watermark_image'],
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'watermark_image': watermarkImage,
      };
}
