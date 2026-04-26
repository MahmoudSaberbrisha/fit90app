import 'package:fit90_gym_main/core/utils/functions/base_one_response.dart';
import 'package:fit90_gym_main/features/inbody/data/models/all_inbody.dart';

class MyInbodyModel extends BaseOneResponse {
  const MyInbodyModel({super.status, super.data, super.message});

  factory MyInbodyModel.fromJson(Map<String, dynamic> json) {
    print('=== MyInbodyModel.fromJson Debug ===');
    print('json keys: ${json.keys}');
    print('json[code]: ${json['code']}');
    print('json[status]: ${json['status']}');
    print('json[success]: ${json['success']}');
    print('json[data]: ${json['data']}');
    print('json[data] type: ${json['data']?.runtimeType}');

    // دعم format الجديد: { code: 0, message: "...", data: [...] }
    // أو format القديم: { status: int, message: "...", data: [...] }
    // أو format من Backend: { success: true, data: [...], count: ... }
    int? statusValue;
    if (json.containsKey('code')) {
      statusValue = json['code'] is int
          ? json['code'] as int?
          : int.tryParse(json['code'].toString());
    } else if (json.containsKey('status')) {
      statusValue = json['status'] is int
          ? json['status'] as int?
          : int.tryParse(json['status'].toString());
    } else if (json.containsKey('success') && json['success'] == true) {
      statusValue = 0; // Treat success: true as code: 0
    }

    // Handle data - could be List directly or nested
    List<AllInbody>? inbodyList;
    if (json['data'] != null) {
      dynamic dataValue = json['data'];

      // If data is a List directly
      if (dataValue is List) {
        print('data is List with ${dataValue.length} items');
        inbodyList = dataValue
            .map((e) {
              try {
                return AllInbody.fromJson(e as Map<String, dynamic>);
              } catch (e) {
                print('Error parsing inbody item: $e');
                return null;
              }
            })
            .whereType<AllInbody>()
            .toList();
      }
      // If data is Map with nested structure (e.g., {data: {invoices: [...]}})
      else if (dataValue is Map) {
        // Check for nested invoices (from inbodyInvoiceController)
        if (dataValue.containsKey('invoices')) {
          final invoices = dataValue['invoices'];
          if (invoices is List) {
            print('Found nested invoices, extracting ${invoices.length} items');
            inbodyList = invoices
                .map((e) {
                  try {
                    return AllInbody.fromJson(e as Map<String, dynamic>);
                  } catch (e) {
                    print('Error parsing inbody invoice: $e');
                    return null;
                  }
                })
                .whereType<AllInbody>()
                .toList();
          }
        }
      }
    }

    print('Final inbodyList length: ${inbodyList?.length ?? 0}');

    return MyInbodyModel(
      status: statusValue,
      message: json['message'] as String?,
      data: inbodyList ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
