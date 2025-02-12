import '../../../../core/util/generic/useCase/sync_use_case.dart';
import '../entities/first_page_entity.dart';
import '../repositories/authentication_repository.dart';

class FirstPageUseCase implements SyncUseCase<FirstPageEntity, void> {
  final AuthenticationRepository repository;

  FirstPageUseCase(this.repository);

  @override
  FirstPageEntity call(void _) {
    return repository.firstPage();
  }
}
