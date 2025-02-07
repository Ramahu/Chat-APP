import '../entities/user.dart';
import '../repositories/chat_list_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class GetChatListUseCase {
  final ChatListRepository repository;
  GetChatListUseCase( this.repository);

  Future<Either<Failure,List<UserEntity>>> call(String currentUserId) async{
    return await repository.getUserListFromFirebase(currentUserId);
  }
}
