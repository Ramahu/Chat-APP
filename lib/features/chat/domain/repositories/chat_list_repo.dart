import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class ChatListRepository {
  Future<Either<Failure,List<UserEntity>>> getUserListFromFirebase(String currentUserId);
}
