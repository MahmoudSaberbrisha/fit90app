import '../../../domain/entities/register_entity.dart';

class RegisterModel extends RegisterEntity {
  dynamic status;
  String? message;
  Map<String, dynamic>? data;

  RegisterModel({this.status, this.message, this.data})
      : super(
          responseMessage: message ?? "تم إنشاء الحساب بنجاح",
          statusCode: status is int ? status : (status == "success" || status == "succeed" ? 201 : 200),
        );

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    // الـ API قد يرجع:
    // 1. {"status":"success","data":{"user":{...}}} (قبل المعالجة)
    // 2. {"code":0,"data":{...},"message":""} (بعد المعالجة من interceptor)
    // 3. {user object مباشرة} (إذا استخرج interceptor data.user)
    
    dynamic statusValue;
    String? messageValue;
    Map<String, dynamic>? dataValue;
    
    // التحقق من وجود status أو code
    if (json.containsKey('status')) {
      statusValue = json['status'];
    } else if (json.containsKey('code')) {
      statusValue = json['code'] == 0 ? "success" : json['code'];
    } else {
      // إذا لم يكن هناك status أو code، يعني أن JSON هو user object مباشرة
      // اعتبره نجاح
      statusValue = "success";
    }
    
    // استخراج message
    messageValue = json['message'] as String?;
    
    // إذا كان status هو "success" أو "succeed"، اعتبره نجاح
    if (statusValue == "success" || statusValue == "succeed" || statusValue == 0 || statusValue == 201) {
      messageValue = messageValue ?? "تم إنشاء الحساب بنجاح";
    }
    
    // استخراج data
    if (json.containsKey('data')) {
      if (json['data'] is Map<String, dynamic>) {
        dataValue = json['data'] as Map<String, dynamic>;
      }
    } else {
      // إذا لم يكن هناك data، يعني أن JSON نفسه هو user object
      // استخدم JSON كـ data
      dataValue = json;
    }
    
    return RegisterModel(
      status: statusValue,
      message: messageValue,
      data: dataValue,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        if (data != null) 'data': data,
      };
}
