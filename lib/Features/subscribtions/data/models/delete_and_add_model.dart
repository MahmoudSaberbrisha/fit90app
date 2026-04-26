import 'package:fit90_gym_main/core/utils/functions/base_one_response.dart';

class DeleteAndAddModel extends BaseOneResponse {
  const DeleteAndAddModel({super.status, super.message});

  factory DeleteAndAddModel.fromJson(Map<String, dynamic> json) {
    // دعم format الجديد: { code: 0, message: "...", data: {...} }
    // أو format القديم: { status: int, message: "..." }
    // أو data object مباشرة (مثل الاشتراك) - في هذه الحالة نعتبره نجاح
    int? statusValue;
    String? messageValue;

    if (json.containsKey('code')) {
      statusValue = json['code'] is int
          ? json['code'] as int?
          : int.tryParse(json['code'].toString());
      messageValue = json['message'] as String?;
    } else if (json.containsKey('status')) {
      statusValue = json['status'] is int
          ? json['status'] as int?
          : int.tryParse(json['status'].toString());
      messageValue = json['message'] as String?;
    } else {
      // إذا لم يكن هناك code أو status، يعني أن هذا data object مباشرة
      // نعتبره نجاح (0) لأن onSuccess يتم استدعاؤه فقط عند النجاح
      statusValue = 0;
      messageValue = json['message'] as String?;
    }

    return DeleteAndAddModel(
      status: statusValue ?? 0, // افتراضي 0 (نجاح)
      message: messageValue,
    );
  }

  Map<String, dynamic> toJson() => {'status': status, 'message': message};
}
