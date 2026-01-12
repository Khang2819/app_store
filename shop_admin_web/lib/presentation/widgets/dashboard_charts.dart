import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// Import State để lấy class MonthlyDataPoint
import '../bloc/dashboard/admin_dashboard_state.dart';

class DashboardCharts extends StatelessWidget {
  final bool isMobile;
  // Thêm tham số nhận dữ liệu
  final List<MonthlyDataPoint> revenueData;
  final List<MonthlyDataPoint> pieData;

  const DashboardCharts({
    super.key,
    this.isMobile = false,
    required this.revenueData, // Nhận data từ cha
    required this.pieData, // Nhận data từ cha
  });

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Column(
          children: [
            _buildLineChart(),
            const SizedBox(height: 24),
            _buildPieChart(),
          ],
        )
        : Row(
          children: [
            Expanded(child: _buildLineChart()),
            const SizedBox(width: 24),
            Expanded(child: _buildPieChart()),
          ],
        );
  }

  Widget _buildLineChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: 'Doanh thu năm nay (triệu ₫)'),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            LineSeries<MonthlyDataPoint, String>(
              dataSource: revenueData, // Dùng dữ liệu thật
              xValueMapper: (MonthlyDataPoint data, _) => data.month,
              yValueMapper: (MonthlyDataPoint data, _) => data.value,
              name: 'Doanh thu',
              color: Colors.blue.shade600,
              markerSettings: const MarkerSettings(isVisible: true),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SfCircularChart(
          title: ChartTitle(
            text: 'Số lượng sản phẩm theo danh mục',
          ), // Sửa tiêu đề cho đúng logic mới
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <PieSeries<MonthlyDataPoint, String>>[
            PieSeries<MonthlyDataPoint, String>(
              dataSource: pieData, // Dùng dữ liệu thật
              xValueMapper:
                  (MonthlyDataPoint data, _) =>
                      data.month, // Lưu ý: 'month' ở đây đóng vai trò là tên Category
              yValueMapper: (MonthlyDataPoint data, _) => data.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              explode: true,
              explodeIndex: 0,
            ),
          ],
        ),
      ),
    );
  }
}
