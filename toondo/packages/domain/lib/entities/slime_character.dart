class SlimeCharacter {
  final String name;
  final List<String> conversationHistory;
  final String rolePrompt;
  final List<String> props;
  final String animationState;

  const SlimeCharacter({
    required this.name,
    this.conversationHistory = const [],
    required this.rolePrompt,
    this.props = const [],
    required this.animationState,
  });

  @override
  String toString() {
    return 'SlimeCharacter(name: $name, conversationHistory: $conversationHistory, rolePrompt: $rolePrompt, props: $props, animationState: $animationState)';
  }
}
