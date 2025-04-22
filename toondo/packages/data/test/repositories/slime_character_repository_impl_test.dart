import 'package:data/models/slime_character_model.dart';
import 'package:data/repositories/slime_character_repository_impl.dart';
import 'package:domain/entities/slime_character.dart';
import 'package:domain/repositories/slime_character_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SlimeCharacterRepository repository;

  setUp(() {
    repository = SlimeCharacterRepositoryImpl();
  });

  group('SlimeCharacterRepositoryImpl', () {
    test('getSlimeCharacter should return default character on first call', () async {
      // Act
      final result = await repository.getSlimeCharacter();
      
      // Assert
      expect(result, isA<SlimeCharacter>());
      expect(result.name, equals('슬라임'));
      expect(result.animationState, equals('idle'));
      expect(result.props, isEmpty);
      expect(result.conversationHistory, isEmpty);
    });
    
    test('updateAnimationState should update the animation state', () async {
      // Arrange
      const newAnimation = 'happy';
      
      // Act
      await repository.updateAnimationState(newAnimation);
      final result = await repository.getSlimeCharacter();
      
      // Assert
      expect(result.animationState, equals(newAnimation));
    });
    
    test('addConversation should add message to conversation history', () async {
      // Arrange
      const message = '안녕!';
      
      // Act
      await repository.addConversation(message);
      final result = await repository.getSlimeCharacter();
      
      // Assert
      expect(result.conversationHistory, contains(message));
      expect(result.conversationHistory.length, equals(1));
    });
    
    test('updateProps should update the props list', () async {
      // Arrange
      final props = ['hat', 'glasses'];
      
      // Act
      await repository.updateProps(props);
      final result = await repository.getSlimeCharacter();
      
      // Assert
      expect(result.props, equals(props));
    });
    
    test('isSpecialAnimationUnlocked should return true for any animation in current implementation', () async {
      // Act
      final result = await repository.isSpecialAnimationUnlocked('dance');
      
      // Assert
      expect(result, isTrue);
    });
    
    test('getAvailableAnimations should return list of basic animations', () async {
      // Act
      final result = await repository.getAvailableAnimations();
      
      // Assert
      expect(result, isA<List<String>>());
      expect(result, isNotEmpty);
      // 현재 구현에서는 기본 애니메이션들이 항상 포함되어야 함
      expect(result, containsAll(['id', 'eye', 'angry', 'happy', 'shine', 'melt']));
    });
    
    test('getSlimeStateBasedOnGoals should return default state', () async {
      // Act
      final result = await repository.getSlimeStateBasedOnGoals();
      
      // Assert
      expect(result, equals('shine'));
    });
    
    test('multiple operations should maintain state correctly', () async {
      // Arrange
      const newAnimation = 'melt';
      const message = '반가워!';
      final props = ['crown'];
      
      // Act
      await repository.updateAnimationState(newAnimation);
      await repository.addConversation(message);
      await repository.updateProps(props);
      final result = await repository.getSlimeCharacter();
      
      // Assert
      expect(result.animationState, equals(newAnimation));
      expect(result.conversationHistory, contains(message));
      expect(result.props, equals(props));
      expect(result.name, equals('슬라임'));
    });
  });
}