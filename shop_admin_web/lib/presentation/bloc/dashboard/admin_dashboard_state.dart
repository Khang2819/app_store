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
  final String userTrend;
  final String orderTrend;
  final String revenueTrend;
  final String productTrend;
  final List<MonthlyDataPoint> monthlyRevenueData;
  final List<MonthlyDataPoint> categoryData;
  const AdminDashboardState({
    this.isLoading = true,
    this.errorMessage,
    this.totalUsers = '...',
    this.totalOrders = '...',
    this.totalRevenue = '...',
    this.totalProducts = '...',
    this.userTrend = '0%',
    this.orderTrend = '0%',
    this.revenueTrend = '0%',
    this.productTrend = '0%',
    this.monthlyRevenueData = const [],
    this.categoryData = const [],
  });
  AdminDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? totalUsers,
    String? totalOrders,
    String? totalRevenue,
    String? totalProducts,
    String? userTrend,
    String? orderTrend,
    String? revenueTrend,
    String? productTrend,
    List<MonthlyDataPoint>? monthlyRevenueData,
    List<MonthlyDataPoint>? categoryData,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      totalUsers: totalUsers ?? this.totalUsers,
      totalOrders: totalOrders ?? this.totalOrders,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalProducts: totalProducts ?? this.totalProducts,
      userTrend: userTrend ?? this.userTrend,
      orderTrend: orderTrend ?? this.orderTrend,
      revenueTrend: revenueTrend ?? this.revenueTrend,
      productTrend: productTrend ?? this.productTrend,
      monthlyRevenueData: monthlyRevenueData ?? this.monthlyRevenueData,
      categoryData: categoryData ?? this.categoryData,
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
    userTrend,
    orderTrend,
    revenueTrend,
    productTrend,
    monthlyRevenueData,
    categoryData,
  ];
}
