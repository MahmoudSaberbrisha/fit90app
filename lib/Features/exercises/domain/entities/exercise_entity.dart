import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String? id;
  final String? catIdFk;
  final String? title;
  final String? tamrenFor;
  final String? magmo3at;
  final String? tkrar;
  final String? restInSec;
  final String? instructions;
  final String? catName;
  final String? mainImage;
  final List<String>? allImages;
  
  // الحقول الجديدة من API (Classes)
  final String? className;
  final String? description;
  final int? trainerId;
  final int? branchId;
  final int? hallId;
  final String? classDate;
  final String? startTime;
  final String? endTime;
  final int? maxCapacity;
  final int? currentEnrollments;
  final double? price;
  final String? status;
  final String? notes;
  final bool? isActive;
  final TrainerInfo? trainer;
  final BranchInfo? branch;
  final HallInfo? hall;
  final List<EnrollmentInfo>? enrollments;

  const ExerciseEntity({
    this.id,
    this.catIdFk,
    this.title,
    this.tamrenFor,
    this.magmo3at,
    this.tkrar,
    this.restInSec,
    this.instructions,
    this.catName,
    this.mainImage,
    this.allImages,
    this.className,
    this.description,
    this.trainerId,
    this.branchId,
    this.hallId,
    this.classDate,
    this.startTime,
    this.endTime,
    this.maxCapacity,
    this.currentEnrollments,
    this.price,
    this.status,
    this.notes,
    this.isActive,
    this.trainer,
    this.branch,
    this.hall,
    this.enrollments,
  });

  @override
  List<Object?> get props => [
        id,
        catIdFk,
        title,
        tamrenFor,
        magmo3at,
        tkrar,
        restInSec,
        instructions,
        catName,
        mainImage,
        allImages,
        className,
        description,
        trainerId,
        branchId,
        hallId,
        classDate,
        startTime,
        endTime,
        maxCapacity,
        currentEnrollments,
        price,
        status,
        notes,
        isActive,
        trainer,
        branch,
        hall,
        enrollments,
      ];
}

class TrainerInfo extends Equatable {
  final int? id;
  final String? name;
  final String? phone;
  final String? email;

  const TrainerInfo({
    this.id,
    this.name,
    this.phone,
    this.email,
  });

  @override
  List<Object?> get props => [id, name, phone, email];
}

class BranchInfo extends Equatable {
  final int? id;
  final String? arabicName;
  final String? englishName;

  const BranchInfo({
    this.id,
    this.arabicName,
    this.englishName,
  });

  @override
  List<Object?> get props => [id, arabicName, englishName];
}

class HallInfo extends Equatable {
  final int? id;
  final String? name;
  final String? hallNumber;

  const HallInfo({
    this.id,
    this.name,
    this.hallNumber,
  });

  @override
  List<Object?> get props => [id, name, hallNumber];
}

class EnrollmentInfo extends Equatable {
  final int? id;
  final int? classId;
  final int? memberId;
  final String? attendanceStatus;
  final String? enrollmentDate;
  final MemberInfo? member;

  const EnrollmentInfo({
    this.id,
    this.classId,
    this.memberId,
    this.attendanceStatus,
    this.enrollmentDate,
    this.member,
  });

  @override
  List<Object?> get props => [id, classId, memberId, attendanceStatus, enrollmentDate, member];
}

class MemberInfo extends Equatable {
  final int? id;
  final String? name;
  final String? memberCode;
  final String? phone;

  const MemberInfo({
    this.id,
    this.name,
    this.memberCode,
    this.phone,
  });

  @override
  List<Object?> get props => [id, name, memberCode, phone];
}
