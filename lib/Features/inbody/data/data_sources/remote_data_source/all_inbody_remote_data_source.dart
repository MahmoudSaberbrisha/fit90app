import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fit90_gym_main/core/utils/constants.dart';
import 'package:fit90_gym_main/core/utils/functions/setup_service_locator.dart';
import 'package:fit90_gym_main/features/spa/data/models/spa_model.dart';
import 'package:fit90_gym_main/features/spa/data/models/spa_model_response.dart';
import 'package:fit90_gym_main/features/spa/domain/entities/spa_entity.dart';
import 'package:hive/hive.dart';
import '../../../../../../core/utils/network/api/network_api.dart';
import '../../../../../../core/utils/network/network_request.dart';
import '../../../../../../core/utils/network/network_utils.dart';
import '../../../../auth/login/domain/entities/employee_entity.dart';

typedef AllInbodyResponse = Either<String, SpaList>;

abstract class AllInbodyRemoteDataSource {
  Future<AllInbodyResponse> fetchAllInbody(String userId);
}

class AllInbodyRemoteDataSourceImpl extends AllInbodyRemoteDataSource {
  @override
  Future<AllInbodyResponse> fetchAllInbody(String userId) async {
    var box = Hive.box<EmployeeEntity>(kEmployeeDataBox);
    AllInbodyResponse allInbodyResponse = left("");
    var queryParams = {"page": "1", "limit": "100"};
    print('=== Inbody fetchAllInbody Debug (using /services API) ===');
    print('userId: $userId');
    print('queryParams: $queryParams');
    await getIt<NetworkRequest>().requestFutureData<SpaModelResponse>(
      Method.get,
      queryParams: queryParams,
      options: Options(contentType: Headers.jsonContentType),
      url: NewApi.doServerServicesList, // استخدام نفس API الخاص بالـ spa
      newBaseUrl: NewApi.baseUrl,
      onSuccess: (data) {
        // onSuccess يتم استدعاؤه عندما يكون isList: false
        // data هو SpaModelResponse (نفس الـ Model المستخدم في الـ spa)
        print('=== Inbody onSuccess Debug (using SpaModelResponse) ===');
        print('data type: ${data.runtimeType}');
        print('data.status: ${data.status}');
        print('data.message: ${data.message}');
        print('data.data: ${data.data}');
        print('data.data type: ${data.data?.runtimeType}');

        if (data.data is List) {
          print('data.data is List with ${(data.data as List).length} items');
          if ((data.data as List).isNotEmpty) {
            print('First item: ${(data.data as List).first}');
          }
        } else if (data.data is Map) {
          print('data.data is Map with keys: ${(data.data as Map).keys}');
        }

        bool isSuccess = false;

        // Check status
        if (data.status != null) {
          if (data.status == 200 || data.status == 0) {
            isSuccess = true;
            print('✅ Success: status is ${data.status}');
          } else if (data.status.toString().toLowerCase() == "success") {
            isSuccess = true;
            print('✅ Success: status is "success"');
          }
        }

        // If we have data (even if empty list), consider it success
        if (data.data != null) {
          isSuccess = true;
          print('✅ Success: data.data is not null');
        }

        // Parse the data - SpaModelResponse.fromJson already handles all structures
        if (data.data != null && data.data is List) {
          final dataList = data.data as List;
          print('✅ data.data is List with ${dataList.length} items');

          // Convert List<dynamic> to List<Spa>
          final spaList = dataList
              .map((e) {
                try {
                  if (e is Spa) {
                    return e;
                  } else if (e is Map<String, dynamic>) {
                    return Spa.fromJson(e);
                  } else {
                    print(
                      'Warning: item is not Spa or Map, type: ${e.runtimeType}',
                    );
                    return null;
                  }
                } catch (e) {
                  print('Error parsing spa service: $e');
                  return null;
                }
              })
              .whereType<Spa>()
              .toList();

          print('✅ Parsed ${spaList.length} spa services for inbody');
          if (spaList.isNotEmpty) {
            print(
              'First service: ${spaList.first.arabicName} - ${spaList.first.price}',
            );
          }
          allInbodyResponse = right(spaList);
        } else if (isSuccess) {
          // Success but no data or empty - return empty list
          print('⚠️ Success but data.data is not a List or is null');
          print('data.data type: ${data.data?.runtimeType}');
          allInbodyResponse = right([]);
        } else {
          print('❌ Failed to fetch data');
          allInbodyResponse = left(data.message ?? "فشل جلب البيانات");
        }
      },
      onError: (code, msg) {
        allInbodyResponse = left(msg.toString());
      },
    );
    return allInbodyResponse;
  }
}
