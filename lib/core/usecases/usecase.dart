import 'package:dartz/dartz.dart';
import 'package:mero_choice_application/core/error/failures.dart';

abstract interface class UsecaseWithParams<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract interface class UsecaseWithoutParams<Type> {
  Future<Either<Failure, Type>> call(); 
}
