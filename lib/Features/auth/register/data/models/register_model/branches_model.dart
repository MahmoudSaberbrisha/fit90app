import 'branches.dart';

class BranchesModel {
  int? status;
  String? message;
  List<Types>? data;

  BranchesModel({this.status, this.message, this.data});

  factory BranchesModel.fromJson(Map<String, dynamic> json) {
    // الـ API يرجع {"code":0,"data":{"data":[...]}} أو {"status":"success","data":[...]}
    // أو قد يأتي json كـ {"data": {...}} فقط (من BaseResponse)
    
    // استخراج code/status
    int? statusValue;
    if (json.containsKey('code')) {
      statusValue = json['code'] as int?;
    } else if (json.containsKey('status')) {
      if (json['status'] is int) {
        statusValue = json['status'] as int?;
      } else if (json['status'] == "success" || json['status'] == "succeed") {
        statusValue = 200;
      }
    }
    
    // استخراج message
    String? messageValue = json['message'] as String?;
    
    // استخراج data
    dynamic dataValue = json['data'];
    
    // إذا كان dataValue هو Map ويحتوي على 'data'، استخرجه
    if (dataValue is Map<String, dynamic> && dataValue.containsKey('data')) {
      dataValue = dataValue['data'];
    }
    
    // إذا كان dataValue هو List، استخدمه مباشرة
    List<dynamic>? dataList;
    if (dataValue is List) {
      dataList = dataValue;
    } else if (dataValue is Map && dataValue.containsKey('data') && dataValue['data'] is List) {
      dataList = dataValue['data'] as List<dynamic>?;
    }
    
    return BranchesModel(
      status: statusValue ?? 200,
      message: messageValue,
      data: dataList?.map((e) => Types.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
