import 'package:equatable/equatable.dart';

class MonthlyDataPoint extends Equatable {
  final String month;
  final double value;
  const MonthlyDataPoint(this.month, this.value);

  @override
  List<Object> get props => [month, value];
}

class AdminDashboardState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final String totalUsers;
  final String totalOrders;
  final String totalRevenue;
  final String totalProducts;
  final List<MonthlyDataPoint> monthlyRevenueData;
  final List<MonthlyDataPoint> monthlyUserSignups;
  final List<MonthlyDataPoint> monthlyOrderCounts;
  final List<MonthlyDataPoint> monthlyProductAdditions;
  const AdminDashboardState({
    this.isLoading = true,
    this.errorMessage,
    this.totalUsers = '...',
    this.totalOrders = '...',
    this.totalRevenue = '...',
    this.totalProducts = '...',
    this.monthlyRevenueData = const [],
    this.monthlyUserSignups = const [],
    this.monthlyOrderCounts = const [],
    this.monthlyProductAdditions = const [],
  });
  AdminDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? totalUsers,
    String? totalOrders,
    String? totalRevenue,
    String? totalProducts,
    List<MonthlyDataPoint>? monthlyRevenueData,
    List<MonthlyDataPoint>? monthlyUserSignups,
    List<MonthlyDataPoint>? monthlyOrderCounts,
    List<MonthlyDataPoint>? monthlyProductAdditions,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      totalUsers: totalUsers ?? this.totalUsers,
      totalOrders: totalOrders ?? this.totalOrders,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalProducts: totalProducts ?? this.totalProducts,
      monthlyRevenueData: monthlyRevenueData ?? this.monthlyRevenueData,
      monthlyUserSignups: monthlyUserSignups ?? this.monthlyUserSignups,
      monthlyOrderCounts: monthlyOrderCounts ?? this.monthlyOrderCounts,
      monthlyProductAdditions:
          monthlyProductAdditions ?? this.monthlyProductAdditions,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    totalUsers,
    totalOrders,
    totalRevenue,
    totalProducts,
    monthlyRevenueData,
    monthlyUserSignups,
    monthlyOrderCounts,
    monthlyProductAdditions,
  ];
}
