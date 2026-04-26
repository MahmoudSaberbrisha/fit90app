import 'package:fit90_gym_main/features/spa/domain/entities/spa_entity.dart';

class Spa extends SpaEntity {
  const Spa({
    super.id,
    super.serviceCode,
    super.arabicName,
    super.englishName,
    super.description,
    super.price,
    super.duration,
    super.branchId,
    super.isActive,
    super.serviceStatus,
    super.imageUrl,
  });

  factory Spa.fromJson(Map<String, dynamic> json) {
    return Spa(
      id: json["id"] is int
          ? json["id"]
          : int.tryParse(json["id"]?.toString() ?? ""),
      serviceCode: json["serviceCode"]?.toString(),
      arabicName: json["arabicName"]?.toString(),
      englishName: json["englishName"]?.toString(),
      description: json["description"]?.toString(),
      price: json["price"] is double
          ? json["price"]
          : json["price"] is int
              ? (json["price"] as int).toDouble()
              : double.tryParse(json["price"]?.toString() ?? ""),
      duration: json["duration"] is int
          ? json["duration"]
          : int.tryParse(json["duration"]?.toString() ?? ""),
      branchId: json["branchId"] is int
          ? json["branchId"]
          : int.tryParse(json["branchId"]?.toString() ?? ""),
      isActive: json["isActive"] is bool
          ? json["isActive"]
          : json["isActive"]?.toString().toLowerCase() == "true" ||
              json["isActive"] == 1,
      serviceStatus: json["serviceStatus"]?.toString(),
      imageUrl: json["imageUrl"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": super.id,
        "serviceCode": super.serviceCode,
        "arabicName": super.arabicName,
        "englishName": super.englishName,
        "description": super.description,
        "price": super.price,
        "duration": super.duration,
        "branchId": super.branchId,
        "isActive": super.isActive,
        "serviceStatus": super.serviceStatus,
        "imageUrl": super.imageUrl,
      };
}
