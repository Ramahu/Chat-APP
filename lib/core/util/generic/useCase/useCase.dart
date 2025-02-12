import '../../../error/failures.dart';
import 'package:dartz/dartz.dart';


abstract class UseCase<Output, Input> {
  Future<Either<Failure, Output?>> call(Input input);

}
