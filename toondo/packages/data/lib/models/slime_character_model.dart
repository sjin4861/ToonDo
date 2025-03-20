import 'package:hive/hive.dart';
import 'package:domain/entities/slime_character.dart';

part 'slime_character_model.g.dart';

@HiveType(typeId: 4)
class SlimeCharacterModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> conversationHistory;

  @HiveField(2)
  String rolePrompt;

  @HiveField(3)
  List<String> props;

  @HiveField(4)
  String animationState;

  SlimeCharacterModel({
    required this.name,
    required this.conversationHistory,
    required this.rolePrompt,
    required this.props,
    required this.animationState,
  });

  // Entity → Model conversion
  factory SlimeCharacterModel.fromEntity(SlimeCharacter entity) {
    return SlimeCharacterModel(
      name: entity.name,
      conversationHistory: entity.conversationHistory,
      rolePrompt: entity.rolePrompt,
      props: entity.props,
      animationState: entity.animationState,
    );
  }

  // Model → Entity conversion
  SlimeCharacter toEntity() {
    return SlimeCharacter(
      name: name,
      conversationHistory: conversationHistory,
      rolePrompt: rolePrompt,
      props: props,
      animationState: animationState,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'conversationHistory': conversationHistory,
      'rolePrompt': rolePrompt,
      'props': props,
      'animationState': animationState,
    };
  }

  factory SlimeCharacterModel.fromJson(Map<String, dynamic> json) {
    return SlimeCharacterModel(
      name: json['name'],
      conversationHistory: List<String>.from(
        json['conversationHistory'] as List,
      ),
      rolePrompt: json['rolePrompt'],
      props: List<String>.from(json['props'] as List),
      animationState: json['animationState'],
    );
  }
}
