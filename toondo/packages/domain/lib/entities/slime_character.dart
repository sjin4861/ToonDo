class SlimeCharacter {
  final String name;
  final List<String> conversationHistory;
  final String rolePrompt;
  final List<String> props;
  final String animationState;

  const SlimeCharacter({
    required this.name,
    required this.conversationHistory,
    required this.rolePrompt,
    required this.props,
    required this.animationState,
  });

  @override
  String toString() {
    return 'SlimeCharacter(name: $name, animationState: $animationState)';
  }
}
