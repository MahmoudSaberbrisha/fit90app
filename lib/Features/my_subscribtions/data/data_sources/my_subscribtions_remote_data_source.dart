import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fit90_gym_main/core/utils/functions/setup_service_locator.dart';
import 'package:fit90_gym_main/features/my_subscribtions/data/models/my_messages_model/my_subscribtions.dart';
import 'package:fit90_gym_main/features/my_subscribtions/data/models/my_messages_model/my_subscribtions_model.dart';

import '../../../../../core/utils/network/api/network_api.dart';
import '../../../../../core/utils/network/network_request.dart';
import '../../../../../core/utils/network/network_utils.dart';

typedef MySubscribtionsResponse = Either<String, AllSubscribtionsList>;

abstract class MySubscribtionsRemoteDataSource {
  Future<MySubscribtionsResponse> fetchAllMosalat({int? memberId});
}

class MySubscribtionsRemoteDataSourceImpl
    extends MySubscribtionsRemoteDataSource {
  @override
  Future<MySubscribtionsResponse> fetchAllMosalat({int? memberId}) async {
    MySubscribtionsResponse allMosalatResponse = left("");

    // الـ API الجديد يستخدم GET مع query parameters
    var queryParams = {"page": "1", "limit": "100"};

    // إضافة memberId في query params إذا كان موجوداً
    if (memberId != null) {
      queryParams["memberId"] = memberId.toString();
    }

    await getIt<NetworkRequest>().requestFutureData<MySubscribtionsModel>(
      Method.get,
      queryParams: queryParams,
      options: Options(contentType: Headers.jsonContentType),
      url: NewApi.doServerGetMySubscribtions,
      newBaseUrl: NewApi.baseUrl,
      isList: false, // تغيير إلى false لأننا نريد Model وليس List مباشرة
      onSuccess: (data) {
        print('=== MySubscribtions Success ===');
        print(
          'Received MySubscribtionsModel with ${data.data?.length ?? 0} subscriptions',
        );
        print('Requested memberId: $memberId');

        if ((data.status == 0 ||
                data.status == 200 ||
                data.status == "success") &&
            data.data != null &&
            data.data is List) {
          // فلترة الاشتراكات بناءً على memberId
          List<MySubscribtions> filteredList =
              (data.data as List).cast<MySubscribtions>();

          print('Total subscriptions before filtering: ${filteredList.length}');

          if (memberId != null) {
            // عرض أول 3 اشتراكات للتحقق من memberId
            for (int i = 0; i < filteredList.length && i < 3; i++) {
              print(
                'Subscription $i - memIdFk: ${filteredList[i].memIdFk}, memberId: $memberId',
              );
            }

            filteredList = filteredList.where((sub) {
              final subMemberId = sub.memIdFk;
              if (subMemberId != null) {
                try {
                  final parsedId = int.parse(subMemberId);
                  final matches = parsedId == memberId;
                  if (matches) {
                    print(
                      '✅ Match found: subscription ${sub.subsId} belongs to member $memberId',
                    );
                  }
                  return matches;
                } catch (e) {
                  print('❌ Error parsing subMemberId: $subMemberId, error: $e');
                  return false;
                }
              }
              return false;
            }).toList();
            print(
              'Filtered to ${filteredList.length} subscriptions for memberId: $memberId',
            );
          } else {
            print('⚠️ No memberId provided, returning all subscriptions');
          }

          if (filteredList.isNotEmpty) {
            print('✅ Returning ${filteredList.length} subscriptions');
            allMosalatResponse = right(filteredList);
          } else {
            print('❌ No subscriptions found after filtering');
            allMosalatResponse = left(
              memberId != null
                  ? "لا توجد اشتراكات خاصة بك"
                  : "لا توجد اشتراكات",
            );
          }
        } else if ((data.status == 0 ||
                data.status == 200 ||
                data.status == "success") &&
            (data.data == null ||
                (data.data is List && (data.data as List).isEmpty))) {
          print('❌ Empty data list');
          allMosalatResponse = left(data.message ?? "لا توجد اشتراكات");
        } else {
          print('❌ Failed status: ${data.status}');
          allMosalatResponse = left(data.message ?? "فشل جلب البيانات");
        }
      },
      onError: (code, msg) {
        allMosalatResponse = left(msg.toString());
      },
    );
    return allMosalatResponse;
  }
}
