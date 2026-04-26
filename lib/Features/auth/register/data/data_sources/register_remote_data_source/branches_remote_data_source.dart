import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fit90_gym_main/features/auth/register/data/models/register_model/branches_model.dart';
import 'package:fit90_gym_main/features/auth/register/data/models/register_model/branches.dart';
import 'package:fit90_gym_main/core/utils/functions/setup_service_locator.dart';

import '../../../../../../core/utils/network/api/network_api.dart';
import '../../../../../../core/utils/network/network_request.dart';
import '../../../../../../core/utils/network/network_utils.dart';

typedef TypeBranchesaResponse = Either<String, TypeBranchesList>;

abstract class TypeBranchesRemoteDataSource {
  Future<TypeBranchesaResponse> fetchTypesBranches();
}

class TypeBranchesRemoteDataSourceImpl extends TypeBranchesRemoteDataSource {
  @override
  Future<TypeBranchesaResponse> fetchTypesBranches() async {
    TypeBranchesaResponse typeBranchesResponse = left("");

    await getIt<NetworkRequest>().requestFutureData<BranchesModel>(
      Method.get,
      options: Options(contentType: Headers.jsonContentType),
      url: NewApi.doServerAllBranches,
      newBaseUrl: NewApi.baseUrl,
      onSuccess: (data) {
        // التحقق من حالة النجاح
        // code: 0 أو status: 200 أو status: "success" يعني نجاح
        bool isSuccess = false;
        if (data.status != null) {
          if (data.status is int) {
            int statusInt = data.status as int;
            isSuccess = statusInt == 200 || statusInt == 0 || statusInt == 201;
          } else if (data.status is String) {
            String statusStr = data.status as String;
            isSuccess = statusStr == "success" || statusStr == "succeed";
          }
        }

        // إذا كانت العملية ناجحة وكانت هناك بيانات
        if (isSuccess && data.data != null && data.data!.isNotEmpty) {
          typeBranchesResponse = right(data.data!);
        } else if (isSuccess && (data.data == null || data.data!.isEmpty)) {
          typeBranchesResponse = left(data.message ?? "لا توجد بيانات");
        } else {
          typeBranchesResponse = left(data.message ?? "فشل جلب البيانات");
        }
      },
      onError: (code, msg) {
        typeBranchesResponse = left(msg.toString());
      },
    );
    return typeBranchesResponse;
  }
}
