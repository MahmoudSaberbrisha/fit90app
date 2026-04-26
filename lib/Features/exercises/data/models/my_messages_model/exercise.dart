
import '../../../domain/entities/exercise_entity.dart';

typedef AllExercisesList = List<ExerciseEntity>?;

class Exercise extends ExerciseEntity {
  const Exercise({
    super.id,
    super.catIdFk,
    super.title,
    super.tamrenFor,
    super.magmo3at,
    super.tkrar,
    super.restInSec,
    super.instructions,
    super.catName,
    super.mainImage,
    super.allImages,
    super.className,
    super.description,
    super.trainerId,
    super.branchId,
    super.hallId,
    super.classDate,
    super.startTime,
    super.endTime,
    super.maxCapacity,
    super.currentEnrollments,
    super.price,
    super.status,
    super.notes,
    super.isActive,
    super.trainer,
    super.branch,
    super.hall,
    super.enrollments,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    // دعم البيانات الجديدة من API (Classes)
    if (json.containsKey("className") || json.containsKey("classDate")) {
      // البيانات الجديدة من Classes API
      return Exercise(
        id: json["id"]?.toString(),
        className: json["className"]?.toString(),
        description: json["description"]?.toString(),
        trainerId: json["trainerId"] is int 
            ? json["trainerId"] 
            : int.tryParse(json["trainerId"]?.toString() ?? ""),
        branchId: json["branchId"] is int 
            ? json["branchId"] 
            : int.tryParse(json["branchId"]?.toString() ?? ""),
        hallId: json["hallId"] is int 
            ? json["hallId"] 
            : int.tryParse(json["hallId"]?.toString() ?? ""),
        classDate: json["classDate"]?.toString(),
        startTime: json["startTime"]?.toString(),
        endTime: json["endTime"]?.toString(),
        maxCapacity: json["maxCapacity"] is int 
            ? json["maxCapacity"] 
            : int.tryParse(json["maxCapacity"]?.toString() ?? ""),
        currentEnrollments: json["currentEnrollments"] is int 
            ? json["currentEnrollments"] 
            : int.tryParse(json["currentEnrollments"]?.toString() ?? ""),
        price: json["price"] is double 
            ? json["price"] 
            : json["price"] is int 
                ? (json["price"] as int).toDouble()
                : double.tryParse(json["price"]?.toString() ?? ""),
        status: json["status"]?.toString(),
        notes: json["notes"]?.toString(),
        isActive: json["isActive"] is bool 
            ? json["isActive"] 
            : json["isActive"]?.toString().toLowerCase() == "true" || json["isActive"] == 1,
        trainer: json["trainer"] != null && json["trainer"] is Map<String, dynamic>
            ? TrainerInfo(
                id: json["trainer"]["id"] is int 
                    ? json["trainer"]["id"] 
                    : int.tryParse(json["trainer"]["id"]?.toString() ?? ""),
                name: json["trainer"]["name"]?.toString(),
                phone: json["trainer"]["phone"]?.toString(),
                email: json["trainer"]["email"]?.toString(),
              )
            : null,
        branch: json["branch"] != null && json["branch"] is Map<String, dynamic>
            ? BranchInfo(
                id: json["branch"]["id"] is int 
                    ? json["branch"]["id"] 
                    : int.tryParse(json["branch"]["id"]?.toString() ?? ""),
                arabicName: json["branch"]["arabicName"]?.toString(),
                englishName: json["branch"]["englishName"]?.toString(),
              )
            : null,
        hall: json["hall"] != null && json["hall"] is Map<String, dynamic>
            ? HallInfo(
                id: json["hall"]["id"] is int 
                    ? json["hall"]["id"] 
                    : int.tryParse(json["hall"]["id"]?.toString() ?? ""),
                name: json["hall"]["name"]?.toString(),
                hallNumber: json["hall"]["hallNumber"]?.toString(),
              )
            : null,
        enrollments: json["enrollments"] != null && json["enrollments"] is List
            ? (json["enrollments"] as List)
                .map((e) {
                  if (e is Map<String, dynamic>) {
                    return EnrollmentInfo(
                      id: e["id"] is int ? e["id"] : int.tryParse(e["id"]?.toString() ?? ""),
                      classId: e["classId"] is int ? e["classId"] : int.tryParse(e["classId"]?.toString() ?? ""),
                      memberId: e["memberId"] is int ? e["memberId"] : int.tryParse(e["memberId"]?.toString() ?? ""),
                      attendanceStatus: e["attendanceStatus"]?.toString(),
                      enrollmentDate: e["enrollmentDate"]?.toString(),
                      member: e["member"] != null && e["member"] is Map<String, dynamic>
                          ? MemberInfo(
                              id: e["member"]["id"] is int ? e["member"]["id"] : int.tryParse(e["member"]["id"]?.toString() ?? ""),
                              name: e["member"]["name"]?.toString(),
                              memberCode: e["member"]["memberCode"]?.toString(),
                              phone: e["member"]["phone"]?.toString(),
                            )
                          : null,
                    );
                  }
                  return null;
                })
                .whereType<EnrollmentInfo>()
                .toList()
            : null,
        // استخدام className كـ title للتوافق مع الكود القديم
        title: json["className"]?.toString(),
        // استخدام description كـ tamrenFor للتوافق مع الكود القديم
        tamrenFor: json["description"]?.toString(),
      );
    }
    // دعم البيانات الجديدة من API (Exercises)
    else if (json.containsKey("name") || json.containsKey("categoryId")) {
      // البيانات الجديدة من Exercises API
      return Exercise(
        id: json["id"]?.toString(),
        catIdFk: json["categoryId"]?.toString() ?? json["cat_id_fk"]?.toString(),
        title: json["name"]?.toString() ?? json["title"]?.toString(),
        tamrenFor: json["description"]?.toString() ?? json["tamren_for"]?.toString(),
        magmo3at: json["duration"]?.toString() ?? json["magmo3at"]?.toString(),
        tkrar: json["difficulty"]?.toString() ?? json["tkrar"]?.toString(),
        restInSec: json["rest_in_sec"]?.toString(),
        instructions: json["instructions"]?.toString(),
        catName: (json["category"] is Map<String, dynamic> 
            ? json["category"]["name"]?.toString() 
            : null) ?? json["cat_name"]?.toString(),
        // استخدام imageUrl من API الجديد أو main_image من API القديم
        mainImage: json["imageUrl"]?.toString() ?? json["main_image"]?.toString(),
        allImages: List<String>.from(json["all_images"] ?? []),
      );
    } else {
      // البيانات القديمة من API
      return Exercise(
        id: json["id"]?.toString(),
        catIdFk: json["cat_id_fk"]?.toString(),
        title: json["title"]?.toString(),
        tamrenFor: json["tamren_for"]?.toString(),
        magmo3at: json["magmo3at"]?.toString(),
        tkrar: json["tkrar"]?.toString(),
        restInSec: json["rest_in_sec"]?.toString(),
        instructions: json["instructions"]?.toString(),
        catName: json["cat_name"]?.toString(),
        mainImage: json["main_image"]?.toString(),
        allImages: List<String>.from(json["all_images"] ?? []),
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "cat_id_fk": catIdFk,
        "title": title,
        "tamren_for": tamrenFor,
        "magmo3at": magmo3at,
        "tkrar": tkrar,
        "rest_in_sec": restInSec,
        "instructions": instructions,
        "cat_name": catName,
        "main_image": mainImage,
        "all_images": allImages,
      };
}
