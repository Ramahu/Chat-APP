import '../../../../core/util/generic/useCase/useCase.dart';
import '../entities/user.dart';
import '../repositories/chat_list_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class GetChatListUseCase implements UseCase<List<UserEntity>, String>{
  final ChatListRepository repository;

  GetChatListUseCase( this.repository);

  @override
  Future<Either<Failure,List<UserEntity>>> call(String currentUserId) async{
    return await repository.getUserListFromFirebase(currentUserId);
  }
}
