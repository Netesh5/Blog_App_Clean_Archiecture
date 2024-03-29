import 'package:clean_arch_application/core/error/exception.dart';
import 'package:clean_arch_application/features/auth/data/models/user_model.dart';
import 'package:clean_arch_application/features/auth/domain/entities/params/login_param.dart';
import 'package:clean_arch_application/features/auth/domain/entities/params/signup_param.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signupWithEmail(SignupParam param);
  Future<UserModel> loginWithEmail(LoginParam param);
  Session? get currentUserSession;
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  SupabaseClient client;
  AuthRemoteDataSourceImp({
    required this.client,
  });

  @override
  Session? get currentUserSession => client.auth.currentSession;

  @override
  Future<UserModel> loginWithEmail(LoginParam param) async {
    try {
      final res = await client.auth
          .signInWithPassword(email: param.email, password: param.password);
      return UserModel.fromJson(res.user!.toJson()).copyWith(
        email: currentUserSession?.user.email ?? "",
        uid: currentUserSession?.user.id ?? "",
      );
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signupWithEmail(SignupParam param) async {
    try {
      final res = await client.auth.signUp(
        email: param.email,
        password: param.password,
        data: {
          'name': param.name,
        },
      );
      if (res.user == null) throw CustomException(message: "User is null");
      return UserModel.fromJson(res.user!.toJson()).copyWith(
        email: currentUserSession?.user.email ?? "",
        uid: currentUserSession?.user.id ?? "",
      );
    } catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    if (currentUserSession != null) {
      final res = await client.from("profiles").select().eq(
            'id',
            currentUserSession?.user.id ?? "",
          );
      return UserModel.fromJson(res.first).copyWith(
        email: currentUserSession?.user.email ?? "",
        uid: currentUserSession?.user.id ?? "",
      );
    } else {
      return null;
    }
  }
}
