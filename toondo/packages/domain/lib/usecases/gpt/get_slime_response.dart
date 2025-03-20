import 'package:domain/repositories/gpt_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSlimeResponseUseCase {
  final GptRepository repository;
  GetSlimeResponseUseCase(this.repository);

  Future<String?> call() async {
    return await repository.getSlimeResponse();
  }
}
