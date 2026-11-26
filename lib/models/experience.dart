import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

/// Data Experience sesuai field ExperienceSerializer pada backend.
@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    this.id,
    required this.title,
    required this.description,
    this.category = 'full-time',
    this.categoryDisplay = '',
    this.thumbnail,
    this.startedAt,
    this.endedAt,
    this.isOngoing = false,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = const [],
  });

  /// UUID dibuat oleh server dan hanya dibaca aplikasi.
  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String description;
  final String category;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String categoryDisplay;

  /// Thumbnail opsional, sesuai URLField nullable pada backend.
  final String? thumbnail;

  /// Tanggal mulai dibuat otomatis oleh server.
  @JsonKey(includeToJson: false)
  final DateTime? startedAt;

  /// Null jika pengalaman masih berlangsung.
  final DateTime? endedAt;

  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isOngoing;

  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;

  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;

  @JsonKey(includeToJson: false, defaultValue: <String>[])
  final List<String> starredByNames;

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
