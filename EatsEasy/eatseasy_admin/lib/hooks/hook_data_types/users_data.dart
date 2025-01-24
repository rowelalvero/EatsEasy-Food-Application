import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/users_model.dart';

class FetchUsers {
  final List<User>? users;
  final int currentPage;
  final int totalPages;
  final ApiError? error;
  final bool isLoading;
  final Function? refetch;

  FetchUsers(
      {required this.users,
      required this.currentPage,
      required this.totalPages,
      required this.error,
      required this.isLoading,
      required this.refetch});
}
