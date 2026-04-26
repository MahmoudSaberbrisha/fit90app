import 'package:fit90_gym_main/core/utils/functions/base_one_response.dart';
import 'spa_model.dart';

class SpaModelResponse extends BaseOneResponse {
  const SpaModelResponse({super.status, super.data, super.message});

  factory SpaModelResponse.fromJson(Map<String, dynamic> json) {
    print('=== SpaModelResponse.fromJson Debug ===');
    print('json keys: ${json.keys}');
    print('json[code]: ${json['code']}');
    print('json[status]: ${json['status']}');
    print('json[data]: ${json['data']}');
    print('json[data] type: ${json['data']?.runtimeType}');

    int? statusValue;

    // Handle status/code field (from interceptor: code, or original: status)
    if (json.containsKey('code')) {
      statusValue = json['code'] is int
          ? json['code'] as int?
          : int.tryParse(json['code'].toString());
    } else if (json.containsKey('status')) {
      // Handle "success" string or number
      if (json['status'] is int) {
        statusValue = json['status'] as int?;
      } else if (json['status'] is String &&
          json['status'].toString().toLowerCase() == "success") {
        statusValue = 200; // Treat "success" as 200
      } else {
        statusValue = int.tryParse(json['status'].toString());
      }
    }

    List<Spa>? spaList;

    // Handle different response structures (same as ServicesAndMarketing.tsx)
    // After interceptor: { code: 0, data: { services: { services: [...], pagination: {...} } } }
    // Original: { status: "success", data: { services: { services: [...], pagination: {...} } } }
    if (json['data'] != null) {
      dynamic dataValue = json['data'];
      print('dataValue type: ${dataValue.runtimeType}');

      if (dataValue is Map) {
        print('dataValue keys: ${dataValue.keys}');

        // Check for nested services structure
        if (dataValue.containsKey('services')) {
          final servicesValue = dataValue['services'];
          print('servicesValue type: ${servicesValue.runtimeType}');

          // Structure: { data: { services: { services: [...], pagination: {...} } } }
          if (servicesValue is Map && servicesValue.containsKey('services')) {
            print('Found nested services.services structure');
            final nestedServices = servicesValue['services'];
            if (nestedServices is List) {
              print(
                'nestedServices is List with ${nestedServices.length} items',
              );
              dataValue = nestedServices;
            }
          }
          // Structure: { data: { services: [...] } }
          else if (servicesValue is List) {
            print('servicesValue is List with ${servicesValue.length} items');
            dataValue = servicesValue;
          }
        }
      }

      // If dataValue is now a List, parse it
      if (dataValue is List) {
        print('Parsing ${dataValue.length} spa services');
        spaList = dataValue
            .map((e) {
              try {
                if (e is Map<String, dynamic>) {
                  return Spa.fromJson(e);
                } else {
                  print(
                    'Warning: service item is not Map, type: ${e.runtimeType}',
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
        print('✅ Parsed ${spaList.length} spa services successfully');
      } else {
        print(
          'Warning: dataValue is not a List after processing, type: ${dataValue.runtimeType}',
        );
      }
    }

    // Structure 2: { services: { services: [...], pagination: {...} } } (if data is null)
    if (spaList == null && json.containsKey('services')) {
      print('Trying services key in root');
      final servicesValue = json['services'];
      if (servicesValue is Map && servicesValue.containsKey('services')) {
        final nestedServices = servicesValue['services'];
        if (nestedServices is List) {
          spaList = nestedServices
              .map((e) {
                try {
                  return Spa.fromJson(e as Map<String, dynamic>);
                } catch (e) {
                  print('Error parsing spa service: $e');
                  return null;
                }
              })
              .whereType<Spa>()
              .toList();
        }
      } else if (servicesValue is List) {
        spaList = servicesValue
            .map((e) {
              try {
                return Spa.fromJson(e as Map<String, dynamic>);
              } catch (e) {
                print('Error parsing spa service: $e');
                return null;
              }
            })
            .whereType<Spa>()
            .toList();
      }
    }

    // Structure 3: { data: [...] } - direct array
    if (spaList == null && json['data'] is List) {
      print('data is direct List');
      spaList = (json['data'] as List)
          .map((e) {
            try {
              return Spa.fromJson(e as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing spa service: $e');
              return null;
            }
          })
          .whereType<Spa>()
          .toList();
    }

    print('Final spaList length: ${spaList?.length ?? 0}');

    return SpaModelResponse(
      status: statusValue,
      message: json['message'] as String?,
      data: spaList ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
