import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fit90_gym_main/core/utils/constants.dart';
import 'package:fit90_gym_main/core/utils/functions/setup_service_locator.dart';
import 'package:fit90_gym_main/features/auth/login/domain/entities/employee_entity.dart';
import 'package:fit90_gym_main/features/subscribtions/data/models/delete_and_add_model.dart';
import 'package:hive/hive.dart';

import '../../../../../core/utils/network/api/network_api.dart';
import '../../../../../core/utils/network/network_request.dart';
import '../../../../../core/utils/network/network_utils.dart';

typedef AddSubscribtionsResponse = Either<String, String>;

abstract class AddSubscribtionsRemoteDataSource {
  Future<AddSubscribtionsResponse> addSubscribtions(fromDate, subId);
}

class AddSubscribtionsRemoteDataSourceImpl
    extends AddSubscribtionsRemoteDataSource {
  @override
  Future<AddSubscribtionsResponse> addSubscribtions(fromDate, subId) async {
    AddSubscribtionsResponse addSubscribtionsResponse = left("");
    var box = Hive.box<EmployeeEntity>(kEmployeeDataBox);

    // الـ API الجديد يستخدم startDate, subscriptionTypeId, memberId
    var body = {
      "startDate": fromDate,
      "subscriptionTypeId": int.tryParse(subId.toString()) ?? subId,
      "memberId": box.get(kEmployeeDataBox)?.memId ?? "",
      "status": "upcoming", // جعل الاشتراك غير نشط (قادم)
    };
    await getIt<NetworkRequest>().requestFutureData<DeleteAndAddModel>(
      Method.post,
      params: body,
      options: Options(contentType: Headers.jsonContentType),
      url: NewApi.doServerAddSubscribtions,
      newBaseUrl: NewApi.baseUrl,
      onSuccess: (data) {
        // إذا تم استدعاء onSuccess، يعني أن الـ response نجح (code == 0)
        // لذلك نعتبر العملية ناجحة دائماً
        addSubscribtionsResponse = right(data.message ?? "تمت الإضافة بنجاح");
      },
      onError: (code, msg) {
        addSubscribtionsResponse = left(msg.toString());
      },
    );
    return addSubscribtionsResponse;
  }
}
