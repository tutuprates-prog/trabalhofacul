// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/database_helper.dart';
import '../models/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  bool get isAuthenticated => user != null;

  AuthState copyWith({UserModel? user, bool? isLoading, String? error, bool clearUser = false}) =>
      AuthState(
        user: clearUser ? null : user ?? this.user,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

String _hashPassword(String password) {
  final bytes = utf8.encode(password);
  return sha256.convert(bytes).toString();
}

class AuthNotifier extends StateNotifier<AuthState> {
  final DatabaseHelper _db;

  AuthNotifier(this._db) : super(const AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _db.getUserByEmail(email.trim().toLowerCase());
      if (user == null) {
        state = state.copyWith(isLoading: false, error: 'E-mail não encontrado.');
        return false;
      }
      if (user.passwordHash != _hashPassword(password)) {
        state = state.copyWith(isLoading: false, error: 'Senha incorreta.');
        return false;
      }
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao fazer login: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final emailLower = email.trim().toLowerCase();
      if (await _db.emailExists(emailLower)) {
        state = state.copyWith(isLoading: false, error: 'E-mail já cadastrado.');
        return false;
      }
      final user = UserModel(
        name: name.trim(),
        email: emailLower,
        passwordHash: _hashPassword(password),
      );
      final id = await _db.insertUser(user);
      state = state.copyWith(user: user.copyWith(id: id), isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao cadastrar: $e');
      return false;
    }
  }

  void logout() => state = const AuthState();
  void clearError() => state = state.copyWith(error: null);
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(DatabaseHelper.instance),
);
