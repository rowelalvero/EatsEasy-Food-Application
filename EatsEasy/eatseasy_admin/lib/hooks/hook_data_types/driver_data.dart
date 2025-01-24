
import 'package:eatseasy_admin/models/api_error.dart';
import 'package:eatseasy_admin/models/driver_model.dart';

class FetchDrivers {
  final List<DriverElement>? drivers;
  final int currentPage;
  final int totalPages;
  final ApiError? error;
  final bool isLoading;
  final Function? refetch;

  FetchDrivers(
      {required this.drivers,
      required this.currentPage,
      required this.totalPages,
      required this.error,
      required this.isLoading,
      required this.refetch});
}
