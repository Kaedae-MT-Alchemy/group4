import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_button.dart';

/// Admin Portal prototype (separate from the public website).
///
/// Shows the admin navigation from the brief, a dashboard overview,
/// course management (Draft -> Published -> Archived) with an "Add course"
/// Form, and order management (Pending -> Paid -> Processing -> Shipped ->
/// Delivered). All data is local demo data; there is no backend.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  static const List<(String, IconData)> _menu = [
    ('Dashboard', Icons.dashboard_outlined),
    ('Users', Icons.people_outline),
    ('Organizations', Icons.business_outlined),
    ('Courses', Icons.school_outlined),
    ('Modules', Icons.view_module_outlined),
    ('Assessments', Icons.quiz_outlined),
    ('Certificates', Icons.workspace_premium_outlined),
    ('Products', Icons.inventory_2_outlined),
    ('Orders', Icons.receipt_long_outlined),
    ('Payments', Icons.payments_outlined),
    ('Inventory', Icons.warehouse_outlined),
    ('Content', Icons.article_outlined),
    ('Testimonials', Icons.format_quote_outlined),
    ('Impact Stories', Icons.auto_stories_outlined),
    ('Reports', Icons.bar_chart_outlined),
    ('Settings', Icons.settings_outlined),
  ];

  static const List<String> _courseStatuses = ['Draft', 'Published', 'Archived'];
  static const List<String> _orderStatuses = [
    'Pending',
    'Paid',
    'Processing',
    'Shipped',
    'Delivered',
  ];

  int _selected = 0;

  final List<Map<String, String>> _courses = [
    {'title': 'Emotional Intelligence Fundamentals', 'status': 'Published'},
    {'title': 'Leadership Development', 'status': 'Published'},
    {'title': 'Team Engagement', 'status': 'Draft'},
    {'title': 'Workplace Well-being', 'status': 'Archived'},
  ];

  final List<Map<String, String>> _orders = [
    {'no': '#MA1001', 'customer': 'Aisha R.', 'amount': 'RM120', 'status': 'Paid'},
    {'no': '#MA1002', 'customer': 'ABC Sdn Bhd', 'amount': 'RM85', 'status': 'Shipped'},
    {'no': '#MA1003', 'customer': 'Daniel T.', 'amount': 'RM49', 'status': 'Pending'},
  ];

  final _courseFormKey = GlobalKey<FormState>();
  final _courseTitle = TextEditingController();

  @override
  void dispose() {
    _courseTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Admin Portal  •  ${_menu[_selected].$1}'),
        backgroundColor: AppTheme.deepBlue,
        foregroundColor: Colors.white,
      ),
      drawer: wide ? null : Drawer(child: _sideMenu(closeOnTap: true)),
      body: Row(
        children: [
          if (wide) SizedBox(width: 240, child: _sideMenu()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: _content(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideMenu({bool closeOnTap = false}) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          for (var i = 0; i < _menu.length; i++)
            ListTile(
              dense: true,
              selected: _selected == i,
              selectedTileColor: AppTheme.softYellow.withValues(alpha: 0.35),
              selectedColor: AppTheme.deepBlue,
              leading: Icon(_menu[i].$2),
              title: Text(_menu[i].$1),
              onTap: () {
                setState(() => _selected = i);
                if (closeOnTap) Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  Widget _content() {
    switch (_menu[_selected].$1) {
      case 'Dashboard':
        return _dashboard();
      case 'Courses':
        return _courseManagement();
      case 'Orders':
        return _orderManagement();
      default:
        return _comingSoon(_menu[_selected].$1);
    }
  }

  // ---------------------------------------------------------------- Dashboard

  Widget _dashboard() {
    final stats = <(String, String, IconData)>[
      ('Users', '1,248', Icons.people_outline),
      ('Organizations', '36', Icons.business_outlined),
      ('Published courses',
          '${_courses.where((c) => c['status'] == 'Published').length}',
          Icons.school_outlined),
      ('Open orders',
          '${_orders.where((o) => o['status'] != 'Delivered').length}',
          Icons.receipt_long_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppTheme.deepBlue,
          ),
        ),
        const SizedBox(height: 4),
        const Text('Sample figures for the prototype.'),
        const SizedBox(height: 18),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: stats
              .map((s) => Container(
                    width: 220,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4E0E9)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(s.$3, color: AppTheme.purple),
                        const SizedBox(height: 12),
                        Text(
                          s.$2,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.deepBlue,
                          ),
                        ),
                        Text(s.$1),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ------------------------------------------------------- Course management

  Widget _courseManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Course management',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppTheme.deepBlue,
          ),
        ),
        const SizedBox(height: 4),
        const Text('Status flow: Draft → Published → Archived'),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE4E0E9)),
          ),
          child: Form(
            key: _courseFormKey,
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 360,
                  child: TextFormField(
                    controller: _courseTitle,
                    decoration: const InputDecoration(labelText: 'New course title'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter a course title'
                        : null,
                  ),
                ),
                AppButton(
                  label: 'Add course',
                  icon: Icons.add,
                  onPressed: _addCourse,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._courses.map(_courseRow),
      ],
    );
  }

  Widget _courseRow(Map<String, String> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E0E9)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              course['title']!,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.deepBlue,
              ),
            ),
          ),
          DropdownButton<String>(
            value: course['status'],
            underline: const SizedBox.shrink(),
            items: _courseStatuses
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => course['status'] = v);
            },
          ),
          IconButton(
            tooltip: 'Delete course',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => setState(() => _courses.remove(course)),
          ),
        ],
      ),
    );
  }

  void _addCourse() {
    if (!_courseFormKey.currentState!.validate()) return;
    setState(() {
      _courses.insert(0, {'title': _courseTitle.text.trim(), 'status': 'Draft'});
      _courseTitle.clear();
    });
  }

  // -------------------------------------------------------- Order management

  Widget _orderManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order management',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppTheme.deepBlue,
          ),
        ),
        const SizedBox(height: 4),
        const Text('Pending → Paid → Processing → Shipped → Delivered'),
        const SizedBox(height: 18),
        ..._orders.map(
          (order) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE4E0E9)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    order['no']!,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                Expanded(child: Text(order['customer']!)),
                Text(order['amount']!),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: order['status'],
                  underline: const SizedBox.shrink(),
                  items: _orderStatuses
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => order['status'] = v);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _comingSoon(String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4E0E9)),
      ),
      child: Text(
        '$name management will be built in the full project '
        '(Checkpoints 2 and 3).',
        style: const TextStyle(fontSize: 16, color: AppTheme.greyText),
      ),
    );
  }
}
