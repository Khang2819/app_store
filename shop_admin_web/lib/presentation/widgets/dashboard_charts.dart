import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardCharts extends StatelessWidget {
  final bool isMobile;
  DashboardCharts({super.key, this.isMobile = false});

  // Line chart data
  final List<_ChartData> lineData = [
    _ChartData('Tháng 1', 30),
    _ChartData('Tháng 2', 45),
    _ChartData('Tháng 3', 50),
    _ChartData('Tháng 4', 70),
    _ChartData('Tháng 5', 60),
    _ChartData('Tháng 6', 90),
    _ChartData('Tháng 7', 30),
    _ChartData('Tháng 8', 45),
    _ChartData('Tháng 9', 50),
    _ChartData('Tháng 10', 70),
    _ChartData('Tháng 11', 60),
    _ChartData('Tháng 12', 90),
  ];

  // Pie chart data
  final List<_PieData> pieData = [
    _PieData('Cà phê', 100),
    _PieData('Trà sữa', 30),
  ];

  @override
  Widget build(BuildContext context) {
    // Desktop: row, Mobile: column
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
          title: ChartTitle(text: 'Doanh thu theo tháng (triệu ₫)'),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            LineSeries<_ChartData, String>(
              dataSource: lineData,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.y,
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
          title: ChartTitle(text: 'Tỷ lệ sản phẩm bán ra'),
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <PieSeries<_PieData, String>>[
            PieSeries<_PieData, String>(
              dataSource: pieData,
              xValueMapper: (_PieData data, _) => data.category,
              yValueMapper: (_PieData data, _) => data.value,
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

// ================= Data Models =================
class _ChartData {
  final String x;
  final double y;
  _ChartData(this.x, this.y);
}

class _PieData {
  final String category;
  final double value;
  _PieData(this.category, this.value);
}
