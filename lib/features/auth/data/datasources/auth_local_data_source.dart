import 'package:dartz/dartz.dart';
import '../../../../core/network/local/cache_helper.dart';

abstract class AuthLocalDataSource {
  Future<Unit> cacheUid(String currentUserId);
  Future<String?> getCachedUid();
  Future<Unit> removeCachedUid();
}

const cachedUid = "Uid";

class AuthLocalDataSourceImpl implements AuthLocalDataSource {

  @override
  Future<Unit> cacheUid(String currentUserId) async {
    await CacheHelper.saveData(
        key: cachedUid, value: currentUserId);
    return Future.value(unit);
  }

  @override
  Future<String?> getCachedUid() async{
    String uid = await CacheHelper.getData(key: cachedUid);
    return uid;
  }

  @override
  Future<Unit> removeCachedUid() async {
  await CacheHelper.remove(key: cachedUid);
    return Future.value(unit);
  }
}