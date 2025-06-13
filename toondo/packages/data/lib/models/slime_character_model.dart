import 'package:hive/hive.dart';
import 'package:domain/entities/slime_character.dart';

part 'slime_character_model.g.dart';

@HiveType(typeId: 4)                    // 1️⃣ 유니크 번호
class SlimeCharacterModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final List<String> conversationHistory;

  @HiveField(2)
  final String rolePrompt;

  @HiveField(3)
  final List<String> props;

  @HiveField(4)
  final String animationState;

  SlimeCharacterModel({
    required this.name,
    required this.conversationHistory,
    required this.rolePrompt,
    required this.props,
    required this.animationState,
  });

  factory SlimeCharacterModel.fromEntity(SlimeCharacter e) =>
      SlimeCharacterModel(
        name: e.name,
        conversationHistory: List<String>.from(e.conversationHistory), // 2️⃣
        rolePrompt: e.rolePrompt,
        props: List<String>.from(e.props),
        animationState: e.animationState,
      );

  SlimeCharacter toEntity() => SlimeCharacter(
        name: name,
        conversationHistory: List<String>.from(conversationHistory),
        rolePrompt: rolePrompt,
        props: List<String>.from(props),
        animationState: animationState,
      );

  factory SlimeCharacterModel.fromJson(Map<String, dynamic> json) =>
      SlimeCharacterModel(
        name: json['name'] as String,
        conversationHistory:
            List<String>.from(json['conversationHistory'] as List),
        rolePrompt: json['rolePrompt'] as String,
        props: List<String>.from(json['props'] as List),
        animationState: json['animationState'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'conversationHistory': conversationHistory,
        'rolePrompt': rolePrompt,
        'props': props,
        'animationState': animationState,
      };
}
