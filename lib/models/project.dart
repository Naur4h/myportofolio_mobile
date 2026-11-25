import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Model proyek sesuai ProjectSerializer pada backend Django.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    this.id,
    required this.title,
    required this.description,
    required this.techStack,
    this.codeUrl = '',
    this.demoUrl = '',
    this.thumbnail = '',
  });

  /// ID integer diberikan server dan tidak dikirim pada POST.
  @JsonKey(includeToJson: false)
  final int? id;

  final String title;
  final String description;
  final String techStack;

  /// Field URL backend opsional; null dan field yang tidak ada menjadi ''.
  @JsonKey(defaultValue: '')
  final String codeUrl;

  @JsonKey(defaultValue: '')
  final String demoUrl;

  @JsonKey(defaultValue: '')
  final String thumbnail;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
