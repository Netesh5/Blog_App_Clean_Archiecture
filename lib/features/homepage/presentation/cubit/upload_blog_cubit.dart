// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_arch_application/features/homepage/domain/entities/blog_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clean_arch_application/features/homepage/domain/entities/blog.dart';
import 'package:clean_arch_application/features/homepage/domain/usecases/upload_blog_interactor.dart';

part 'blog_state.dart';

class UploadBlogCubit extends Cubit<BlogState> {
  final UploadBlogInteractor interactor;
  UploadBlogCubit({
    required this.interactor,
  }) : super(BlogInitial());

  void uploadBlog(BlogParams params) async {
    emit(BlogLoading());
    final res = await interactor(params);
    res.fold(
      (l) => emit(BlogFailure(message: l.message)),
      (_) => emit(
        const BlogSuccess(),
      ),
    );
  }
}
