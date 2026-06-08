import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../models/transaction.dart';
import '../widgets/neo_card.dart';

class BerandaView extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction) onAddTransaction;
  final VoidCallback onOpenNotifications;
  final bool hasUnreadNotifications;

  const BerandaView({
    Key? key,
    required this.transactions,
    required this.onAddTransaction,
    required this.onOpenNotifications,
    required this.hasUnreadNotifications,
  }) : super(key: key);

  String formatCurrency(double val) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(val);
  }

  @override
  Widget build(BuildContext context) {
    double totalIncome = 0;
    double totalExpense = 0;
    for (var tx in transactions) {
      if (tx.type == 'pemasukan') {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;
      }
    }
    double totalBalance = totalIncome - totalExpense;

    final latestTransactions = transactions.take(4).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontFamily: 'Display',
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(LucideIcons.bell, color: Colors.white, size: 24),
                    if (hasUnreadNotifications)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF2E93),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: onOpenNotifications,
              ),
            ],
          ),
          const SizedBox(height: 20),

          NeoCard(
            variant: 'yellow',
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Balance',
                  style: TextStyle(
                    fontFamily: 'Display',
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 2.0,
                    color: Color(0xFF5C5200),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatCurrency(totalBalance),
                  style: const TextStyle(
                    fontFamily: 'Display',
                    fontWeight: FontWeight.w900,
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: NeoCard(
                  variant: 'green',
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Income',
                              style: TextStyle(
                                fontFamily: 'Display',
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                                letterSpacing: 1.0,
                                color: Color(0xFF003917),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 1.5),
                              ),
                              child: const Icon(LucideIcons.arrowUpRight, size: 12, color: Color(0xFF007235)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          formatCurrency(totalIncome),
                          style: const TextStyle(
                            fontFamily: 'Display',
                            fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeoCard(
                  variant: 'pink',
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Outflow',
                            style: TextStyle(
                              fontFamily: 'Display',
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                              letterSpacing: 1.0,
                              color: Color(0xFF63003D),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: const Icon(LucideIcons.arrowDownRight, size: 12, color: Color(0xFFAD2571)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        formatCurrency(totalExpense),
                        style: const TextStyle(
                          fontFamily: 'Display',
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Financial Overview (last 6m)',
            style: TextStyle(
              fontFamily: 'Display',
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          NeoCard(
            variant: 'dark',
            padding: const EdgeInsets.fromLTRB(10, 24, 20, 10),
            child: SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 2000000,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) => const FlLine(
                      color: Colors.black26,
                      strokeWidth: 1.5,
                    ),
                    getDrawingVerticalLine: (value) => const FlLine(
                      color: Colors.black26,
                      strokeWidth: 1.5,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const Text('0', style: TextStyle(color: Colors.grey, fontSize: 8));
                          return Text(
                            '${(value / 1000000).toStringAsFixed(0)}M',
                            style: const TextStyle(color: Colors.grey, fontSize: 8),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0: return const Text('JAN', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold));
                            case 1: return const Text('FEB', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold));
                            case 2: return const Text('MAR', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold));
                            case 3: return const Text('APR', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold));
                            case 4: return const Text('MEI', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold));
                            case 5: return const Text('JUN', style: TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black, width: 2.5),
                  ),
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: 10000000,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 8500000),
                        FlSpot(1, 7800000),
                        FlSpot(2, 9200000),
                        FlSpot(3, 8000000),
                        FlSpot(4, 4500000),
                        FlSpot(5, 5200000),
                      ],
                      isCurved: false,
                      color: const Color(0xFF2DE17F),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 4200000),
                        FlSpot(1, 5100000),
                        FlSpot(2, 3800000),
                        FlSpot(3, 4000000),
                        FlSpot(4, 2500000),
                        FlSpot(5, 3100000),
                      ],
                      isCurved: false,
                      color: const Color(0xFFFF2E93),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Latest Transactions',
                style: TextStyle(
                  fontFamily: 'Display',
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1.0,
                  color: Colors.white,
                ),
              ),
              if (latestTransactions.isNotEmpty)
                const Text(
                  '4 Latest Item',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                    letterSpacing: 1.0,
                    color: Color(0xFFFF2E93),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (latestTransactions.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 36),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700, width: 2, style: BorderStyle.none),
              ),
              child: const Text(
                'No Transaction Found',
                style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: latestTransactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final tx = latestTransactions[index];
                final isIncome = tx.type == 'pemasukan';

                return NeoCard(
                  variant: 'surface',
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isIncome ? const Color(0xFF2DE17F) : const Color(0xFFFF2E93),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Text(
                          tx.category.substring(0, 2).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${tx.date} • ${tx.time}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        '${isIncome ? "+" : "-"}Rp ${tx.amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                        style: TextStyle(
                          fontFamily: 'Display',
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: isIncome ? const Color(0xFF2DE17F) : const Color(0xFFFF2E93),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
