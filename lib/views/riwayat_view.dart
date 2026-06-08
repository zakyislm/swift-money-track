import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../models/transaction.dart';
import '../widgets/neo_card.dart';
import '../widgets/neo_button.dart';

class RiwayatView extends StatefulWidget {
  final List<Transaction> transactions;
  final Function(String) onDeleteTransaction;

  const RiwayatView({
    Key? key,
    required this.transactions,
    required this.onDeleteTransaction,
  }) : super(key: key);

  @override
  State<RiwayatView> createState() => _RiwayatViewState();
}

class _RiwayatViewState extends State<RiwayatView> {
  final _searchController = TextEditingController();
  String _activeTab = 'semua'; // 'semua' | 'pemasukan' | 'pengeluaran'
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String formatCurrency(double val) {
    return val.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  // Group transactions by date
  Map<String, List<Transaction>> getGroupedTransactions(List<Transaction> filteredList) {
    final Map<String, List<Transaction>> groups = {};
    for (var tx in filteredList) {
      String key = tx.date;
      // Synthesize elegant group text
      if (tx.date == '2026-06-08') {
        key = 'HARI INI';
      } else if (tx.date == '2026-06-07') {
        key = 'KEMARIN';
      } else {
        // format ISO date roughly
        final parts = tx.date.split('-');
        if (parts.length == 3) {
          final year = parts[0];
          final monthInt = int.tryParse(parts[1]) ?? 1;
          const months = [
            'JANUARI', 'FEBRUARI', 'MARET', 'APRIL', 'MEI', 'JUNI',
            'JULI', 'AGUSTUS', 'SEPTEMBER', 'OKTOBER', 'NOVEMBER', 'DESEMBER'
          ];
          key = '${months[monthInt - 1]} $year';
        }
      }

      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(tx);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filter elements
    final filteredTransactions = widget.transactions.where((tx) {
      final matchesSearch = tx.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          tx.note.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesTab = _activeTab == 'semua' || tx.type == _activeTab;
      
      return matchesSearch && matchesTab;
    }).toList();

    // 2. Statistics calculation
    double filteredIncome = 0;
    double filteredExpense = 0;
    for (var tx in filteredTransactions) {
      if (tx.type == 'pemasukan') {
        filteredIncome += tx.amount;
      } else {
        filteredExpense += tx.amount;
      }
    }
    final filteredNet = filteredIncome - filteredExpense;

    // 3. Grouping
    final groupedMap = getGroupedTransactions(filteredTransactions);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          const Row(
            children: [
              Icon(LucideIcons.dollarSign, color: Color(0xFFFFE600), size: 24),
              SizedBox(width: 8),
              Text(
                'History',
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
          const SizedBox(height: 16),

          // Search Input
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2.5),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: Icon(LucideIcons.search, color: Colors.black87, size: 20),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: 'Cari transaksi...',
                      hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Custom Segmented Tabs Selector (Semua / Masuk / Keluar)
          Row(
            children: [
              Expanded(
                child: NeoButton(
                  variant: _activeTab == 'semua' ? 'yellow' : 'dark',
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  onTap: () => setState(() => _activeTab = 'semua'),
                  child: Center(
                    child: Text(
                      'All',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        color: _activeTab == 'semua' ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NeoButton(
                  variant: _activeTab == 'pemasukan' ? 'green' : 'dark',
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  onTap: () => setState(() => _activeTab = 'pemasukan'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.arrowDown, 
                        size: 13, 
                        color: _activeTab == 'pemasukan' ? Colors.black : const Color(0xFF2DE17F),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Income',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          color: _activeTab == 'pemasukan' ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NeoButton(
                  variant: _activeTab == 'pengeluaran' ? 'pink' : 'dark',
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  onTap: () => setState(() => _activeTab = 'pengeluaran'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.arrowUp, 
                        size: 13, 
                        color: _activeTab == 'pengeluaran' ? Colors.black : const Color(0xFFFF2E93),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Outflow',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          color: _activeTab == 'pengeluaran' ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Main Screen layout: Grouped list + Side statistical container
          if (groupedMap.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 48),
              alignment: Alignment.center,
              child: const Text(
                'No Transactions Found',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupedMap.keys.length,
              itemBuilder: (context, idx) {
                final dateKey = groupedMap.keys.elementAt(idx);
                final list = groupedMap[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date label block indicator
                    Container(
                      margin: const EdgeInsets.only(top: 14, bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2.0),
                      ),
                      child: Text(
                        dateKey,
                        style: const TextStyle(
                          fontFamily: 'Display',
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Inner Group Cards List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, idxInner) {
                        final tx = list[idxInner];
                        final isIncome = tx.type == 'pemasukan';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: NeoCard(
                            variant: 'surface',
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Category block code
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isIncome ? const Color(0xFF2DE17F) : const Color(0xFFFF2E93),
                                    border: Border.all(color: Colors.black, width: 1.5),
                                  ),
                                  child: Text(
                                    tx.category.substring(0, 2).toUpperCase(),
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 10),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Main Text fields
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx.title,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${tx.time} • ${tx.note.isNotEmpty ? tx.note : tx.category}'.toUpperCase(),
                                        style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),

                                // Values & Delete Actions
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${isIncome ? "+" : "-"}Rp ${formatCurrency(tx.amount)}',
                                          style: TextStyle(
                                            fontFamily: 'Display',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                            color: isIncome ? const Color(0xFF2DE17F) : const Color(0xFFFF2E93),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: const Icon(LucideIcons.trash2, color: Colors.grey, size: 14),
                                          onPressed: () => widget.onDeleteTransaction(tx.id),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isIncome ? const Color(0xFF2DE17F).withValues(alpha: 0.12) : const Color(0xFFFF2E93).withValues(alpha: 0.12),
                                        border: Border.all(
                                          color: isIncome ? const Color(0xFF2DE17F).withValues(alpha: 0.3) : const Color(0xFFFF2E93).withValues(alpha: 0.3),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Text(
                                        isIncome ? 'Income' : 'Outflow',
                                        style: TextStyle(
                                          fontSize: 7,
                                          fontWeight: FontWeight.w900,
                                          color: isIncome ? const Color(0xFF2DE17F) : const Color(0xFFFF2E93),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),

          const SizedBox(height: 24),

          // FILTER DIAGNOSIS CARD
          const Text(
            'Filter',
            style: TextStyle(
              fontFamily: 'Display',
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 1.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          NeoCard(
            variant: 'yellow',
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Search Result',
                  style: TextStyle(
                    fontFamily: 'Display',
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Filter Statistic',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.black54),
                ),
                const SizedBox(height: 15),

                // Table Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount Transactions:', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 11)),
                    Text('${filteredTransactions.length} item', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 11)),
                  ],
                ),
                const Divider(color: Colors.black26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Income:', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 11)),
                    Text('+Rp ${formatCurrency(filteredIncome)}', style: const TextStyle(color: Color(0xFF005C21), fontWeight: FontWeight.w900, fontSize: 11)),
                  ],
                ),
                const Divider(color: Colors.black26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Outflow:', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 11)),
                    Text('-Rp ${formatCurrency(filteredExpense)}', style: const TextStyle(color: Color(0xFF900A3F), fontWeight: FontWeight.w900, fontSize: 11)),
                  ],
                ),
                const Divider(color: Colors.black26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Net Balance:', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 11)),
                    Text(
                      '${filteredNet >= 0 ? "+" : "-"}Rp ${formatCurrency(filteredNet.abs())}',
                      style: TextStyle(
                        fontFamily: 'Display',
                        color: filteredNet >= 0 ? const Color(0xFF005C21) : const Color(0xFF900A3F),
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // QUICK INSIGHT CARD
          NeoCard(
            variant: 'dark',
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(LucideIcons.lightbulb, color: Color(0xFFFFE600), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    filteredTransactions.isEmpty
                      ? 'No Transactions Found for the Analytic Suggestion.'
                      : filteredNet >= 0 
                        ? 'Your Cashflow is Positive! Keep it Great !!'
                        : 'Warning! Your Cashflow shows Negative Value, please be wise on Using your Money',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}