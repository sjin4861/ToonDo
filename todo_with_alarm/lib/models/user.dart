class User {
  final String phoneNumber;
  final String password;
  final String username;

  User({
    required this.phoneNumber,
    required this.password,
    this.username = "",
  });
}