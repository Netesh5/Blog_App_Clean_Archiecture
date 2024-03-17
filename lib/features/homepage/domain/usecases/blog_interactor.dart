import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:clean_arch_application/core/error/exception.dart';
import 'package:clean_arch_application/core/error/failure.dart';
import 'package:clean_arch_application/core/usecases/async_usecase.dart';
import 'package:clean_arch_application/features/homepage/domain/entities/blog.dart';
import 'package:clean_arch_application/features/homepage/domain/entities/blog_params.dart';
import 'package:clean_arch_application/features/homepage/domain/repositories/blog_repository.dart';

class BlogInteractor implements AsyncUseCase<Blog, BlogParams> {
  final BlogRepository repository;
  BlogInteractor({
    required this.repository,
  });
  @override
  Future<Either<Failure, Blog>> call(BlogParams param) async {
    try {
      final res = await repository.uploadBlog(
        params: param,
        file: param.file ?? File(param.imageUrl),
      );
      return Right(res);
    } on CustomException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}