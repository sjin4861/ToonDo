import 'package:domain/repositories/gpt_repository.dart';

class GetSlimeResponseUseCase {
  final GptRepository repository;
  GetSlimeResponseUseCase(this.repository);

  Future<String?> call() async {
    return await repository.getSlimeResponse();
  }
}
