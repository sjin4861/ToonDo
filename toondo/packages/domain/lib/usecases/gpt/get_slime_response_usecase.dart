import 'package:domain/repositories/gpt_repository.dart';

class GetSlimeResponseUseCase {
  final GptRepository gptRepository;

  GetSlimeResponseUseCase(this.gptRepository);

  Future<String?> call() async {
    return await gptRepository.getSlimeResponse();
  }
}
