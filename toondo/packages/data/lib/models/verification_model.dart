import 'package:domain/entities/verification.dart';

class VerificationModel extends Verification {
  VerificationModel({required super.phoneNumber, super.code});

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(
      phoneNumber: json['phoneNumber'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber, 'code': code};
  }
}
