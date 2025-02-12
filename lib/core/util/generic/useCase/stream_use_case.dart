import 'package:dartz/dartz.dart';
import '../../../error/failures.dart';

abstract class StreamUseCase<Output, Input> {
  Stream<Either<Failure, Output>> call(Input input);
}
