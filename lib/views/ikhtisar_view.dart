import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../models/transaction.dart';
import '../data/initial_data.dart';
import '../widgets/neo_card.dart';
import '../widgets/neo_button.dart';

class IkhtisarView extends StatefulWidget {
  final List<Transaction> transactions;
  final List<MonthlySummary> monthlySummaries;
  final Function(int) onEstimateMonth;
  final Function(String) onOpenTab;

  const IkhtisarView({
    Key? key,
    required this.transactions,
    required this.monthlySummaries,
    required this.onEstimateMonth,
    required this.onOpenTab,
  }) : super(key: key);

  @override
  State<IkhtisarView> createState() => _IkhtisarViewState();
}

class _IkhtisarViewState extends State<IkhtisarView> {
  bool _showAllMonths = false;
  String? _feedbackMessage;

  String formatCurrency(double val) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(val);
  }

  void _triggerLocalAction(String message) {
    setState(() {
      _feedbackMessage = message;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _feedbackMessage = null;
        });
      }
    });
  }

  void _showMonthDetails(MonthlySummary summary) {
    showDialog(
      context: context,
      builder: (context) {
        final netProfit = summary.income - summary.expense;
        final isProfit = netProfit >= 0;

        return AlertDialog(
          backgroundColor: const Color(0xFF1C1E1F),
          shape: const Border.fromBorderSide(
            BorderSide(color: Colors.black, width: 3.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DETAIL ${summary.monthName}',
                style: const TextStyle(
                  fontFamily: 'Display',
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Stats
              NeoCard(
                variant: isProfit ? 'green' : 'pink',
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ARUS KAS BERSIH',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                        color: Colors.black,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatCurrency(netProfit),
                      style: const TextStyle(
                        fontFamily: 'Display',
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Summary values
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pendapatan:', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                  Text(formatCurrency(summary.income), style: const TextStyle(color: Color(0xFF2DE17F), fontWeight: FontWeight.w900, fontSize: 12)),
                ],
              ),
              const Divider(color: Colors.grey, height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pengeluaran:', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                  Text(formatCurrency(summary.expense), style: const TextStyle(color: Color(0xFFFF2E93), fontWeight: FontWeight.w900, fontSize: 12)),
                ],
              ),
              const Divider(color: Colors.grey, height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rasio Pertumbuhan:', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                  Text(
                    summary.growth >= 0 ? '+${summary.growth}%' : '${summary.growth}%',
                    style: TextStyle(
                      color: summary.growth >= 0 ? const Color(0xFF2DE17F) : const Color(0xFFFF2E93),
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              NeoButton(
                variant: 'yellow',
                onTap: () {
                  Navigator.of(context).pop();
                  _triggerLocalAction('Unduhan Statement Excel untuk ${summary.monthName} berhasil dibuat!');
                },
                child: const Center(
                  child: Text(
                    'UNDUH LAPORAN EXCEL',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine Top 5 Transactions by raw amount
    final sortedTxs = [...widget.transactions]..sort((a, b) => b.amount.compareTo(a.amount));
    final top5Txs = sortedTxs.take(5).toList();

    // Split blended summaries by visibility toggle
    final visibleSummaries = _showAllMonths 
        ? widget.monthlySummaries 
        : widget.monthlySummaries.take(8).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Title Row
          const Row(
            children: [
              Text(
                'Your Transaction Overview',
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
          const SizedBox(height: 15),

          if (_feedbackMessage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2DE17F),
                border: Border.all(color: Colors.black, width: 2.5),
              ),
              child: Text(
                '🎯 UPDATE: $_feedbackMessage'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),

          NeoCard(
            variant: 'yellow',
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2026 Overview',
                  style: TextStyle(
                    fontFamily: 'Display',
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Your 2026 Cash Recap',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Flow Grid Title
          const Text(
            'Monthly Cashflow',
            style: TextStyle(
              fontFamily: 'Display',
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 1.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Monthly Flow Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            itemCount: visibleSummaries.length,
            itemBuilder: (context, idx) {
              final sum = visibleSummaries[idx];
              final isActive = sum.status == 'active' || sum.status == 'estimated';

              return NeoCard(
                variant: 'surface',
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            sum.monthName,
                            style: const TextStyle(
                              fontFamily: 'Display',
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (sum.status == 'estimated')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            color: const Color(0xFFFFE600),
                            child: const Text(
                              'EST',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 7),
                            ),
                          ),
                      ],
                    ),

                    if (isActive) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IN: ${formatCurrency(sum.income)}',
                            maxLines: 1,
                            style: const TextStyle(color: Color(0xFF2DE17F), fontWeight: FontWeight.bold, fontSize: 9),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'OUT: ${formatCurrency(sum.expense)}',
                            maxLines: 1,
                            style: const TextStyle(color: Color(0xFFFF2E93), fontWeight: FontWeight.bold, fontSize: 9),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: NeoButton(
                              variant: 'dark',
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              onTap: () => _showMonthDetails(sum),
                              child: const Center(
                                child: Text('DETAIL', style: TextStyle(color: Color(0xFFFFE600), fontWeight: FontWeight.bold, fontSize: 8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(LucideIcons.download, color: Colors.white, size: 14),
                            onPressed: () => _triggerLocalAction('Excel ${sum.monthName} diunduh ke Memory!'),
                          ),
                        ],
                      ),
                    ] else ...[
                      const Text(
                        'Menunggu data...',
                        style: TextStyle(color: Colors.grey, fontSize: 10, fontStyle: FontStyle.italic),
                      ),
                      NeoButton(
                        variant: 'gray',
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        onTap: () => widget.onEstimateMonth(sum.monthIndex),
                        child: const Center(
                          child: Text('Estimation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 8)),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Visibility Toggler Button
          NeoButton(
            variant: 'dark',
            onTap: () => setState(() => _showAllMonths = !_showAllMonths),
            child: Center(
              child: Text(
                _showAllMonths ? 'Hide' : 'Show',
                style: const TextStyle(
                  fontFamily: 'Display',
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 1.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // TOP 5 TRANSAKSI
          const Text(
            'Top 5 Biggest Transactions',
            style: TextStyle(
              fontFamily: 'Display',
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 1.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          if (top5Txs.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: const Text('No Transaction Found', style: TextStyle(color: Colors.grey)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: top5Txs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final tx = top5Txs[idx];
                final isIncome = tx.type == 'pemasukan';

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF151819),
                    border: Border.all(color: Colors.black, width: 2.2),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isIncome ? const Color(0xFF2DE17F) : const Color(0xFFFF2E93),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Text(
                          tx.title.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 11),
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
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${tx.date} • ${tx.category}',
                              style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
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

          const SizedBox(height: 30),

          // Call to Action Box
          NeoCard(
            variant: 'bright',
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Plan your Future From Now !',
                  style: TextStyle(
                    fontFamily: 'Display',
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Money is like a Compass that you can use for making Decisions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    NeoButton(
                      variant: 'white',
                      onTap: () => widget.onOpenTab('riwayat'),
                      child: const Center(
                        child: Text(
                          'Add New Transactions',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    NeoButton(
                      variant: 'dark',
                      onTap: () => _triggerLocalAction('2026 Transactions Data Downloaded'),
                      child: const Center(
                        child: Text(
                          'Download',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
