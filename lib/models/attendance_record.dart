class AttendanceRecord {
  final String id;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String teacherId;
  final String date; // Format: YYYY-MM-DD

  AttendanceRecord({
    required this.id,
    required this.checkInTime,
    this.checkOutTime,
    required this.teacherId,
    required this.date,
  });

  bool get isCheckedIn => checkOutTime == null;

  Duration? get workDuration {
    if (checkOutTime != null) {
      return checkOutTime!.difference(checkInTime);
    }
    return null;
  }

  String get formattedCheckInTime {
    return '${checkInTime.hour.toString().padLeft(2, '0')}:${checkInTime.minute.toString().padLeft(2, '0')}';
  }

  String? get formattedCheckOutTime {
    if (checkOutTime != null) {
      return '${checkOutTime!.hour.toString().padLeft(2, '0')}:${checkOutTime!.minute.toString().padLeft(2, '0')}';
    }
    return null;
  }

  String get formattedWorkDuration {
    final duration = workDuration;
    if (duration != null) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '${hours}ຊົ່ວໂມງ ${minutes}ນາທີ';
    }
    return 'ຍັງບໍ່ໄດ້ກວດອອກ';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkInTime': checkInTime.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'teacherId': teacherId,
      'date': date,
    };
  }

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String,
      checkInTime: DateTime.parse(json['checkInTime'] as String),
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'] as String)
          : null,
      teacherId: json['teacherId'] as String,
      date: json['date'] as String,
    );
  }

  AttendanceRecord copyWith({
    String? id,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? teacherId,
    String? date,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      teacherId: teacherId ?? this.teacherId,
      date: date ?? this.date,
    );
  }
}
