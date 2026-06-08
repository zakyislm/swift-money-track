import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import 'models/transaction.dart';
import 'models/notification_item.dart';
import 'data/initial_data.dart';
import 'widgets/neo_card.dart';
import 'widgets/neo_button.dart';
import 'widgets/add_transaction_dialog.dart';

import 'views/beranda_view.dart';
import 'views/ikhtisar_view.dart';
import 'views/riwayat_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KeuangankuApp());
}

class KeuangankuApp extends StatelessWidget {
  const KeuangankuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121415),
        fontFamily: 'sans-serif',
        primaryColor: const Color(0xFFFFE600),
      ),
      home: const MainLayoutScreen(),
    );
  }
}

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({Key? key}) : super(key: key);

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  List<Transaction> _transactions = [];
  List<NotificationItem> _notifications = [];
  List<MonthlySummary> _monthlySummaries = [];

  String _currentTab = 'beranda';
  bool _isNotifDrawerOpen = false;
  String _currentTimeString = '';
  late Timer _clockTimer;

  @override
  void initState() {
    super.initState();
    _loadStateFromLocalStorage();
    _startClockTicks();
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  void _startClockTicks() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final format = DateFormat('EEE, d MMM yyyy • HH:mm:ss');
      if (mounted) {
        setState(() {
          _currentTimeString = format.format(now).toUpperCase();
        });
      }
    });
  }

  Future<void> _loadStateFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    
    final txString = prefs.getString('keuanganku_transactions');
    if (txString != null) {
      final List decoded = json.decode(txString);
      _transactions = decoded.map((item) => Transaction.fromJson(item)).toList();
    } else {
      _transactions = List.from(initialTransactions);
    }

    final notifString = prefs.getString('keuanganku_notifications');
    if (notifString != null) {
      final List decoded = json.decode(notifString);
      _notifications = decoded.map((item) => NotificationItem.fromJson(item)).toList();
    } else {
      _notifications = List.from(initialNotifications);
    }

    final summaryString = prefs.getString('keuanganku_monthly_summaries');
    if (summaryString != null) {
      final List decoded = json.decode(summaryString);
      _monthlySummaries = decoded.map((item) => MonthlySummary.fromJson(item)).toList();
    } else {
      _monthlySummaries = List.from(initialMonthlySummaries);
    }

    _recalculateCurrentMonthSummaries();
    setState(() {});
  }

  Future<void> _saveTransactionsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _transactions.map((tx) => tx.toJson()).toList();
    await prefs.setString('keuanganku_transactions', json.encode(data));
  }

  Future<void> _saveNotificationsToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _notifications.map((notif) => notif.toJson()).toList();
    await prefs.setString('keuanganku_notifications', json.encode(data));
  }

  Future<void> _saveMonthlySummariesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _monthlySummaries.map((sum) => sum.toJson()).toList();
    await prefs.setString('keuanganku_monthly_summaries', json.encode(data));
  }

  void _addTransaction(Transaction tx) {
    setState(() {
      _transactions.insert(0, tx);
    });
    _saveTransactionsToStorage();
    _recalculateCurrentMonthSummaries();
    _triggerNotification(
      'New Transactions Added!',
      '${tx.type.toUpperCase()}: ${tx.title} Rp ${tx.amount.toInt()} added successfully.',
    );
  }

  void _deleteTransaction(String id) {
    final target = _transactions.firstWhere((tx) => tx.id == id);
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
    _saveTransactionsToStorage();
    _recalculateCurrentMonthSummaries();

    _triggerNotification(
      'Transactions Deleted',
      'Data "${target.title}" permanently deleted.',
    );
  }

  void _triggerNotification(String title, String message) {
    final formatTime = DateFormat('HH:mm').format(DateTime.now());
    final formatDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final newNotif = NotificationItem(
      id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      date: formatDate,
      time: formatTime,
      isRead: false,
    );

    setState(() {
      _notifications.insert(0, newNotif);
    });
    _saveNotificationsToStorage();
  }

  void _markAllNotificationsRead() {
    setState(() {
      for (var item in _notifications) {
        item.isRead = true;
      }
    });
    _saveNotificationsToStorage();
  }

  void _clearAllNotifications() {
    setState(() {
      _notifications.clear();
    });
    _saveNotificationsToStorage();
  }

  void _recalculateCurrentMonthSummaries() {
    double juneIncome = 0;
    double juneExpense = 0;
    
    for (var tx in _transactions) {
      if (tx.date.startsWith('2026-06')) {
        if (tx.type == 'pemasukan') {
          juneIncome += tx.amount;
        } else {
          juneExpense += tx.amount;
        }
      }
    }

    setState(() {
      final idx = _monthlySummaries.indexWhere((sum) => sum.monthIndex == 5);
      if (idx != -1) {
        final prevJune = _monthlySummaries[idx];
        _monthlySummaries[idx] = MonthlySummary(
          monthIndex: 5,
          monthName: 'JUNI',
          income: juneIncome,
          expense: juneExpense,
          growth: prevJune.growth,
          status: 'active',
        );
      }
    });
    _saveMonthlySummariesToStorage();
  }

  void _estimateMonth(int monthIndex) {
    double totalActiveIn = 0;
    double totalActiveOut = 0;
    int count = 0;

    for (var sum in _monthlySummaries) {
      if (sum.status == 'active' && sum.income > 0) {
        totalActiveIn += sum.income;
        totalActiveOut += sum.expense;
        count++;
      }
    }

    if (count == 0) {
      totalActiveIn = 8000000;
      totalActiveOut = 4000000;
      count = 1;
    }

    final estIn = totalActiveIn / count;
    final estOut = (totalActiveOut / count) * 1.05;

    setState(() {
      final idx = _monthlySummaries.indexWhere((sum) => sum.monthIndex == monthIndex);
      if (idx != -1) {
        final target = _monthlySummaries[idx];
        _monthlySummaries[idx] = MonthlySummary(
          monthIndex: monthIndex,
          monthName: target.monthName,
          income: estIn,
          expense: estOut,
          growth: 4,
          status: 'estimated',
        );
      }
    });

    _saveMonthlySummariesToStorage();
    _triggerNotification(
      'Counted Estimation!',
      'Estimated for ${_monthlySummaries[monthIndex].monthName} with 5% inflation rate.',
    );
  }

  void _openAddTransactionFlow() {
    showDialog(
      context: context,
      builder: (ctx) => AddTransactionDialog(
        onSave: _addTransaction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadNotifs = _notifications.where((n) => !n.isRead).length;
    final hasUnread = unreadNotifs > 0;

    Widget activeBody;
    switch (_currentTab) {
      case 'ikhtisar':
        activeBody = IkhtisarView(
          transactions: _transactions,
          monthlySummaries: _monthlySummaries,
          onEstimateMonth: _estimateMonth,
          onOpenTab: (tab) => setState(() => _currentTab = tab),
        );
        break;
      case 'riwayat':
        activeBody = RiwayatView(
          transactions: _transactions,
          onDeleteTransaction: _deleteTransaction,
        );
        break;
      case 'beranda':
      default:
        activeBody = BerandaView(
          transactions: _transactions,
          onAddTransaction: _addTransaction,
          onOpenNotifications: () => setState(() => _isNotifDrawerOpen = !_isNotifDrawerOpen),
          hasUnreadNotifications: hasUnread,
        );
        break;
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                if (isDesktop)
                  Container(
                    width: 250,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B1D1E),
                      border: Border(
                        right: BorderSide(color: Colors.black, width: 3.5),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Swift',
                          style: TextStyle(
                            fontFamily: 'Display',
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            color: Color(0xFFFFE600),
                            letterSpacing: -1.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Tracker For your Financial',
                          style: TextStyle(
                            fontFamily: 'Mono',
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 35),

                        NeoButton(
                          variant: _currentTab == 'beranda' ? 'yellow' : 'dark',
                          onTap: () => setState(() => _currentTab = 'beranda'),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: const Row(
                            children: [
                              Icon(LucideIcons.home, size: 16, color: Colors.white),
                              SizedBox(width: 12),
                              Text('Home', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        NeoButton(
                          variant: _currentTab == 'ikhtisar' ? 'yellow' : 'dark',
                          onTap: () => setState(() => _currentTab = 'ikhtisar'),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: const Row(
                            children: [
                              Icon(LucideIcons.barChart2, size: 16, color: Colors.white),
                              SizedBox(width: 12),
                              Text('Overview', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        NeoButton(
                          variant: _currentTab == 'riwayat' ? 'yellow' : 'dark',
                          onTap: () => setState(() => _currentTab = 'riwayat'),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: const Row(
                            children: [
                              Icon(LucideIcons.history, size: 16, color: Colors.white),
                              SizedBox(width: 12),
                              Text('History', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.white)),
                            ],
                          ),
                        ),
                        const Spacer(),

                        NeoCard(
                          variant: 'dark',
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Stabilizer', style: TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(
                                _currentTimeString.split(' • ').last,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFFF2E93)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isDesktop)
                              const Text(
                                'Swift',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w900, fontSize: 10, color: Color(0xFFFFE600)),
                              ),
                            Expanded(
                              child: Text(
                                _currentTimeString,
                                textAlign: isDesktop ? TextAlign.left : TextAlign.right,
                                style: const TextStyle(
                                  fontFamily: 'Mono',
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2DE17F),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Expanded(child: activeBody),
                    ],
                  ),
                ),
              ],
            ),

            if (_isNotifDrawerOpen)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: ScreenNotificationDrawer(
                  notifications: _notifications,
                  onClose: () => setState(() => _isNotifDrawerOpen = false),
                  onMarkAllRead: _markAllNotificationsRead,
                  onClearAll: _clearAllNotifications,
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFE600),
        foregroundColor: Colors.black,
        shape: const Border.fromBorderSide(BorderSide(color: Colors.black, width: 2.5)),
        elevation: 6,
        onPressed: _openAddTransactionFlow,
        child: const Icon(LucideIcons.plus, size: 28),
      ),

      bottomNavigationBar: isDesktop
          ? null
          : Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1B1D1E),
                border: Border(
                  top: BorderSide(color: Colors.black, width: 3.5),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomBarItem('beranda', LucideIcons.home, 'Home'),
                  _buildBottomBarItem('ikhtisar', LucideIcons.barChart2, 'Overview'),
                  _buildBottomBarItem('riwayat', LucideIcons.history, 'History'),
                ],
              ),
            ),
    );
  }

  Widget _buildBottomBarItem(String tabName, IconData icon, String label) {
    final isSelected = _currentTab == tabName;
    return InkWell(
      onTap: () => setState(() => _currentTab = tabName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE600) : Colors.transparent,
          border: isSelected ? Border.all(color: Colors.black, width: 2.0) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.black : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenNotificationDrawer extends StatelessWidget {
  final List<NotificationItem> notifications;
  final VoidCallback onClose;
  final VoidCallback onMarkAllRead;
  final VoidCallback onClearAll;

  const ScreenNotificationDrawer({
    Key? key,
    required this.notifications,
    required this.onClose,
    required this.onMarkAllRead,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth > 450 ? 380.0 : screenWidth * 0.85;

    return Container(
      width: drawerWidth,
      decoration: const BoxDecoration(
        color: Color(0xFF1B1D1E),
        border: Border(
          left: BorderSide(color: Colors.black, width: 3.5),
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontFamily: 'Display', fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
              ),
              IconButton(onPressed: onClose, icon: const Icon(Icons.close, color: Colors.white)),
            ],
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: NeoButton(
                  variant: 'dark',
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  onTap: onMarkAllRead,
                  child: const Center(
                    child: Text('Read All', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 8, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NeoButton(
                  variant: 'pink',
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  onTap: onClearAll,
                  child: const Center(
                    child: Text('Delete', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 8, color: Colors.black)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: notifications.isEmpty
                ? const Center(
                    child: Text(
                      'No Recent Notifications',
                      style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final item = notifications[idx];

                      return NeoCard(
                        variant: 'dark',
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 11,
                                      color: item.isRead ? Colors.grey : const Color(0xFFFFE600),
                                    ),
                                  ),
                                ),
                                if (!item.isRead)
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(color: Color(0xFFFF2E93), shape: BoxShape.circle),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.message,
                              style: const TextStyle(color: Colors.white70, fontSize: 9, height: 1.3),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${item.date} • ${item.time}',
                              style: const TextStyle(color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
