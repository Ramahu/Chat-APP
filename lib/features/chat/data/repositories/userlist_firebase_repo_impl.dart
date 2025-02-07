import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/chat_list_repo.dart';
import '../datasources/remote/chat_list_firebase_remote_source.dart';

class ChatListRepoImpl implements ChatListRepository {
  final ChatListFirebaseRemoteSource firebaseRemote;
  final NetworkInfo networkInfo;
  ChatListRepoImpl({required this.networkInfo,required this.firebaseRemote});

  @override
  Future<Either<Failure,List<UserEntity>>> getUserListFromFirebase(String currentUserId) async {
    if (await networkInfo.isConnected) {
      try {
        final listUserEntity = await firebaseRemote.getUserListFromFirebase(currentUserId);
        return  Right(listUserEntity);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }


}
