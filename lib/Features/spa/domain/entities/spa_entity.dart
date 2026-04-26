import 'package:equatable/equatable.dart';

class SpaEntity extends Equatable {
  final int? id;
  final String? serviceCode;
  final String? arabicName;
  final String? englishName;
  final String? description;
  final double? price;
  final int? duration;
  final int? branchId;
  final bool? isActive;
  final String? serviceStatus;
  final String? imageUrl;

  const SpaEntity({
    this.id,
    this.serviceCode,
    this.arabicName,
    this.englishName,
    this.description,
    this.price,
    this.duration,
    this.branchId,
    this.isActive,
    this.serviceStatus,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        serviceCode,
        arabicName,
        englishName,
        description,
        price,
        duration,
        branchId,
        isActive,
        serviceStatus,
        imageUrl,
      ];
}

typedef SpaList = List<SpaEntity>?;

