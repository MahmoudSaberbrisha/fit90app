import 'package:fit90_gym_main/features/auth/register/domain/entities/branches_entity.dart';

typedef TypeBranchesList = List<TypesEntity>?;

class Types extends TypesEntity {
  const Types({super.branchId, super.branchName, super.fromId});

  factory Types.fromJson(Map<String, dynamic> json) => Types(
        branchId: json['id']?.toString() ?? json['branch_id']?.toString(),
        branchName:
            json['arabicName'] ?? json['englishName'] ?? json['branch_name'],
        fromId: json['from_id']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'branch_id': branchId,
        'branch_name': branchName,
        'from_id': fromId,
      };
}
