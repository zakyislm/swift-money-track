import '../models/transaction.dart';
import '../models/notification_item.dart';

class CategoryItem {
  final String name;
  final String icon; // Icon description to map to Lucide icons
  final String color; // 'pink' or 'green' or 'yellow'

  CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class MonthlySummary {
  final int monthIndex;
  final String monthName;
  final double income;
  final double expense;
  final int growth;
  final String status; // 'active' | 'estimated' | 'pending'

  MonthlySummary({
    required this.monthIndex,
    required this.monthName,
    required this.income,
    required this.expense,
    required this.growth,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'monthIndex': monthIndex,
    'monthName': monthName,
    'income': income,
    'expense': expense,
    'growth': growth,
    'status': status,
  };

  factory MonthlySummary.fromJson(Map<String, dynamic> json) => MonthlySummary(
    monthIndex: json['monthIndex'] as int,
    monthName: json['monthName'] as String,
    income: (json['income'] as num).toDouble(),
    expense: (json['expense'] as num).toDouble(),
    growth: json['growth'] as int,
    status: json['status'] as String,
  );
}

final List<CategoryItem> transactionCategories = [
  CategoryItem(name: 'Kebutuhan', icon: 'ShoppingBag', color: 'pink'),
  CategoryItem(name: 'Makanan', icon: 'Utensils', color: 'pink'),
  CategoryItem(name: 'Transportasi', icon: 'Car', color: 'pink'),
  CategoryItem(name: 'Lifestyle', icon: 'Flame', color: 'pink'),
  CategoryItem(name: 'Pendapatan', icon: 'Wallet', color: 'green'),
  CategoryItem(name: 'Investasi', icon: 'TrendingUp', color: 'green'),
  CategoryItem(name: 'Hiburan', icon: 'Gamepad', color: 'pink'),
  CategoryItem(name: 'Pendidikan', icon: 'BookOpen', color: 'pink'),
];

final List<Transaction> initialTransactions = [
  Transaction(
    id: 'tx-today-1',
    title: 'Gaji Freelance UI',
    amount: 2500000,
    type: 'pemasukan',
    category: 'Pendapatan',
    date: '2026-06-08',
    time: '09:00',
    note: 'Desain Landing Page ke-2',
  ),
  Transaction(
    id: 'tx-today-2',
    title: 'Makan Siang Padang',
    amount: 45000,
    type: 'pengeluaran',
    category: 'Makanan',
    date: '2026-06-08',
    time: '13:15',
    note: 'Lauk tunjang + teh es',
  ),
  Transaction(
    id: 'tx-prev-1',
    title: 'Belanja Bulanan',
    amount: 680000,
    type: 'pengeluaran',
    category: 'Kebutuhan',
    date: '2026-06-07',
    time: '20:45',
    note: 'Belanja di Supermarket',
  ),
  Transaction(
    id: 'tx-prev-2',
    title: 'Ojek Online',
    amount: 18500,
    type: 'pengeluaran',
    category: 'Transportasi',
    date: '2026-06-07',
    time: '08:30',
    note: 'Pergi kuliah/kantor',
  ),
  Transaction(
    id: 'tx-hist-1',
    title: 'Gaji Pokok PT Maju Jaya',
    amount: 7500000,
    type: 'pemasukan',
    category: 'Pendapatan',
    date: '2026-03-25',
    time: '08:00',
    note: 'Gaji Pokok Maret 2026',
  ),
  Transaction(
    id: 'tx-hist-2',
    title: 'Belanja Bulanan Supermarket',
    amount: 1250000,
    type: 'pengeluaran',
    category: 'Kebutuhan',
    date: '2026-03-12',
    time: '14:30',
    note: 'Stok bulanan Maret',
  ),
  Transaction(
    id: 'tx-hist-3',
    title: 'Makan Malam Fine Dining',
    amount: 950000,
    type: 'pengeluaran',
    category: 'Lifestyle',
    date: '2026-02-14',
    time: '19:30',
    note: 'Valentine Day Dinner',
  ),
  Transaction(
    id: 'tx-hist-4',
    title: 'Servis Mobil & Ganti Ban',
    amount: 820000,
    type: 'pengeluaran',
    category: 'Transportasi',
    date: '2026-01-05',
    time: '10:15',
    note: 'Bengkel resmi',
  ),
  Transaction(
    id: 'tx-hist-5',
    title: 'Dividen Saham Blue Chip',
    amount: 540000,
    type: 'pemasukan',
    category: 'Investasi',
    date: '2026-01-20',
    time: '11:00',
    note: 'Dividen kuartal 4',
  ),
];

final List<MonthlySummary> initialMonthlySummaries = [
  MonthlySummary(monthIndex: 0, monthName: 'JANUARI', income: 8500000, expense: 4200000, growth: 12, status: 'active'),
  MonthlySummary(monthIndex: 1, monthName: 'FEBRUARI', income: 7800000, expense: 5100000, growth: -5, status: 'active'),
  MonthlySummary(monthIndex: 2, monthName: 'MARET', income: 9200000, expense: 3800000, growth: 2, status: 'active'),
  MonthlySummary(monthIndex: 3, monthName: 'APRIL', income: 8000000, expense: 4000000, growth: 0, status: 'active'),
  MonthlySummary(monthIndex: 4, monthName: 'MEI', income: 0, expense: 0, growth: 0, status: 'pending'),
  MonthlySummary(monthIndex: 5, monthName: 'JUNI', income: 0, expense: 0, growth: 0, status: 'pending'),
  MonthlySummary(monthIndex: 6, monthName: 'JULI', income: 0, expense: 0, growth: 0, status: 'pending'),
  MonthlySummary(monthIndex: 7, monthName: 'AGUSTUS', income: 0, expense: 0, growth: 0, status: 'pending'),
  MonthlySummary(monthIndex: 8, monthName: 'SEPTEMBER', income: 0, expense: 0, growth: 0, status: 'pending'),
  MonthlySummary(monthIndex: 9, monthName: 'OKTOBER', income: 0, expense: 0, growth: 0, status: 'pending'),
  MonthlySummary(monthIndex: 10, monthName: 'NOVEMBER', income: 0, expense: 0, growth: 0, status: 'pending'),
  MonthlySummary(monthIndex: 11, monthName: 'DESEMBER', income: 0, expense: 0, growth: 0, status: 'pending'),
];

final List<NotificationItem> initialNotifications = [
  NotificationItem(
    id: 'notif-1',
    title: 'Batas Gaji Diterima!',
    message: 'Pemasukan dari freelance UI telah dikreditkan ke saldo utama Anda.',
    date: '2026-06-08',
    time: '09:05',
    isRead: false,
  ),
  NotificationItem(
    id: 'notif-2',
    title: 'Reminder Anggaran!',
    message: 'Pengeluaran untuk kategori Makanan mendekati target mingguan Anda.',
    date: '2026-06-07',
    time: '14:20',
    isRead: false,
  ),
  NotificationItem(
    id: 'notif-3',
    title: 'Sistem High-Contrast Siap',
    message: 'Selamat datang di Keuanganku! Kelola budget Anda dengan taktis & brutal.',
    date: '2026-01-01',
    time: '00:00',
    isRead: true,
  ),
];
