// test/auth_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:todo_with_alarm/models/user.dart';
import 'package:todo_with_alarm/services/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    final authService = AuthService();

    test('1. Register new user successfully', () async {
      // Arrange
      final newUser = User(
        phoneNumber: '01012345678',
        password: 'password123',
      );

      // Act
      await authService.registerUser(newUser);

      // Assert
      final isRegistered = await authService.isPhoneNumberRegistered('01012345678');
      expect(isRegistered, true);
    });

    test('2. Fail to register user with existing phone number', () async {
      // Arrange
      final existingUser = User(
        phoneNumber: '01098765432',
        password: 'password456',
      );
      await authService.registerUser(existingUser);

      final duplicateUser = User(
        phoneNumber: '01098765432',
        password: 'newpassword',
      );

      // Act & Assert
      expect(
        () async => await authService.registerUser(duplicateUser),
        throwsException,
      );
    });

    test('3. Login successfully with correct credentials', () async {
      // Arrange
      final user = User(
        phoneNumber: '01055556666',
        password: 'mypassword',
      );
      await authService.registerUser(user);

      // Act
      final loginResult = await authService.login('01055556666', 'mypassword');

      // Assert
      expect(loginResult, true);
    });

    test('4. Fail to login with incorrect password', () async {
      // Arrange
      final user = User(
        phoneNumber: '01077778888',
        password: 'correctpassword',
      );
      await authService.registerUser(user);

      // Act
      final loginResult = await authService.login('01077778888', 'wrongpassword');

      // Assert
      expect(loginResult, false);
    });

    test('5. Check if phone number is registered', () async {
      // Arrange
      final user = User(
        phoneNumber: '01099990000',
        password: 'testpassword',
      );
      await authService.registerUser(user);

      // Act
      final isRegistered = await authService.isPhoneNumberRegistered('01099990000');
      final isNotRegistered = await authService.isPhoneNumberRegistered('01000009999');

      // Assert
      expect(isRegistered, true);
      expect(isNotRegistered, false);
    });
  });
}