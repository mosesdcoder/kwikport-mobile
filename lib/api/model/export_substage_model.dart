// lib/api/model/export_substage_model.dart
class ExportSubStageModel {
  final String id;
  final String subStageName;
  final int order;
  final int estimatedDays;
  final DateTime? startDate;
  final DateTime? completedDate;
  final DateTime? estimatedCompletionDate;
  final bool isCompleted;
  final bool isActive;
  final String? notes;
  final String? hangfireJobId;

  ExportSubStageModel({
    required this.id,
    required this.subStageName,
    required this.order,
    required this.estimatedDays,
    this.startDate,
    this.completedDate,
    this.estimatedCompletionDate,
    required this.isCompleted,
    required this.isActive,
    this.notes,
    this.hangfireJobId,
  });

  factory ExportSubStageModel.fromJson(Map<String, dynamic> json) {
    DateTime? _parse(String? s) => s == null ? null : DateTime.tryParse(s);
    return ExportSubStageModel(
      id: json['id']?.toString() ?? '',
      subStageName: json['subStageName']?.toString() ?? '',
      order: (json['order'] is int) ? json['order'] : int.tryParse('${json['order']}') ?? 0,
      estimatedDays: (json['estimatedDays'] is int) ? json['estimatedDays'] : int.tryParse('${json['estimatedDays']}') ?? 0,
      startDate: _parse(json['startDate']),
      completedDate: _parse(json['completedDate']),
      estimatedCompletionDate: _parse(json['estimatedCompletionDate']),
      isCompleted: json['isCompleted'] == true,
      isActive: json['isActive'] == true,
      notes: json['notes']?.toString(),
      hangfireJobId: json['hangfireJobId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subStageName': subStageName,
        'order': order,
        'estimatedDays': estimatedDays,
        'startDate': startDate?.toIso8601String(),
        'completedDate': completedDate?.toIso8601String(),
        'estimatedCompletionDate': estimatedCompletionDate?.toIso8601String(),
        'isCompleted': isCompleted,
        'isActive': isActive,
        'notes': notes,
        'hangfireJobId': hangfireJobId,
      };
}

