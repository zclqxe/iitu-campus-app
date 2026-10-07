import 'package:flutter/material.dart';

void main() {
  runApp(const MyCampusApp());
}

const iituRed = Color(0xFFC8102E);
const iituDark = Color(0xFF171717);
const pageBg = Color(0xFFF5F5F3);

class AppRoutes {
  static const home = '/';
  static const timetable = '/timetable';
  static const services = '/services';
  static const events = '/events';
  static const profile = '/profile';
  static const serviceDetail = '/service-detail';
}

class MyCampusApp extends StatelessWidget {
  const MyCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IITU Student Campus',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageBg,
        colorScheme: ColorScheme.fromSeed(seedColor: iituRed),
        fontFamily: 'Arial',
      ),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const CampusHomePage(),
        AppRoutes.timetable: (context) => const TimetableScreen(),
        AppRoutes.services: (context) => const CampusServicesScreen(),
        AppRoutes.events: (context) => const CampusEventsScreen(),
        AppRoutes.profile: (context) => const StudentProfileScreen(),
        AppRoutes.serviceDetail: (context) {
          final service =
          ModalRoute.of(context)!.settings.arguments as CampusService;

          return ServiceDetailScreen(service: service);
        },
      },
      // Handles invalid route names and prevents navigation errors.
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => UnknownRouteScreen(
            routeName: settings.name ?? 'Unknown',
          ),
        );
      },

    );
  }
}

class CampusHomePage extends StatefulWidget {
  const CampusHomePage({super.key});

  @override
  State<CampusHomePage> createState() => _CampusHomePageState();
}

class _CampusHomePageState extends State<CampusHomePage> {
  int _currentIndex = 0;
  int _reminderCount = 0;

  final List<String> _titles = const [
    'IITU STUDENT CAMPUS',
    'MY SCHEDULE',
    'MY PROFILE',
  ];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _changePage(int index) {
    setState(() => _currentIndex = index);
  }

  void _openPage(String title, Widget child) {
    // Direct route using MaterialPageRoute for simple information pages.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(title: title, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => _showMessage('No new notifications'),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomePage(),
          _buildSchedulePage(),
          _buildProfilePage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        tooltip: 'Add Reminder',
        onPressed: () {
          setState(() => _reminderCount++);
          _showMessage('Reminder added! Total: $_reminderCount');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        indicatorColor: const Color(0xFFFFDDE3),
        onDestinationSelected: (index) {
          if (index == 2) {
            Navigator.pushNamed(context, AppRoutes.profile);
          } else {
            _changePage(index);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: iituRed),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.school, color: iituRed, size: 30),
                ),
                SizedBox(height: 12),
                Text(
                  'IITU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Student Campus',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.home_outlined, 'Home', () => _changePage(0)),
          _drawerItem(
              Icons.calendar_month_outlined, 'My Schedule', () => _changePage(1)),
          _drawerItem(Icons.person_outline, 'My Profile', () => _changePage(2)),
          const Divider(),
          _drawerItem(
            Icons.school_outlined,
            'Faculties',
                () => _openPage('FACULTIES', _facultiesContent()),
          ),
          _drawerItem(
            Icons.groups_outlined,
            'Student Clubs',
                () => _openPage('STUDENT CLUBS', _clubsContent()),
          ),
          _drawerItem(
            Icons.help_outline,
            'Help Centre',
                () => _openPage('HELP CENTRE', _helpContent()),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback action) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  // ======================== HOME ========================

  Widget _buildHomePage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth > 1180 ? 1120.0 : constraints.maxWidth;
        return SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _hero(),
                    const SizedBox(height: 46),
                    _sectionHeader('STUDENT SERVICES', 'Explore campus'),
                    const SizedBox(height: 10),
                    _servicesGrid(),
                    const SizedBox(height: 48),
                    _sectionHeader('ACADEMIC OVERVIEW', 'Your progress'),
                    const SizedBox(height: 16),
                    _academicOverview(),
                    const SizedBox(height: 48),
                    _sectionHeader('CAMPUS SERVICES', 'For students'),
                    const SizedBox(height: 16),
                    _campusServices(),
                    const SizedBox(height: 48),
                    _sectionHeader('NEWS & EVENTS', 'What’s happening'),
                    const SizedBox(height: 16),
                    _events(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _hero() {
    return Container(
      height: 410,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        image: const DecorationImage(
          image: AssetImage('assets/images/muitiitu.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(34),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withValues(alpha: .82),
              Colors.black.withValues(alpha: .48),
              Colors.transparent,
            ],
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'INTERNATIONAL\nINFORMATION TECHNOLOGY\nUNIVERSITY',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
                height: 1.4,
              ),
            ),
            SizedBox(height: 14),
            Text(
              'THE DIGITAL FUTURE\nBEGINS HERE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                height: .98,
                fontWeight: FontWeight.w900,
                letterSpacing: -.8,
              ),
            ),
            SizedBox(height: 18),
            Row(
              children: [
                Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Almaty, Kazakhstan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String small) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -.3,
              color: iituDark,
            ),
          ),
        ),
        Text(
          small.toUpperCase(),
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _servicesGrid() {
    final items = [
      // Opens the timetable using a named route.
      ('01', 'Schedule', Icons.calendar_month_outlined,
          () => Navigator.pushNamed(context, AppRoutes.timetable)),
      ('02', 'Faculties', Icons.school_outlined,
          () => _openPage('FACULTIES', _facultiesContent())),
      ('03', 'Student Clubs', Icons.groups_outlined,
          () => _openPage('STUDENT CLUBS', _clubsContent())),
      ('04', 'Campus Services', Icons.support_agent_outlined,
          () => Navigator.pushNamed(context, AppRoutes.services)),
      ('05', 'Contacts', Icons.phone_outlined,
          () => _openPage('CONTACTS', _contactsContent())),
      ('06', 'Campus Events', Icons.event_outlined,
          () => Navigator.pushNamed(context, AppRoutes.events)),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final columns = c.maxWidth > 760 ? 3 : 2;
        final width = (c.maxWidth - (columns - 1) * 1) / columns;
        return Wrap(
          children: items.map((item) {
            return SizedBox(
              width: width,
              child: _serviceLink(
                item.$1,
                item.$2,
                item.$3,
                item.$4,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _serviceLink(
      String number, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 118,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE3E3E3), width: .6),
        ),
        child: Row(
          children: [
            Text(
              number,
              style: const TextStyle(
                color: iituRed,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 14),
            Icon(icon, color: iituDark, size: 25),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(Icons.arrow_outward, size: 18, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  Widget _academicOverview() {
    return Container(
      color: iituDark,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: const Row(
        children: [
          Expanded(child: _Stat(value: '3.0', label: 'GPA')),
          _VerticalLine(),
          Expanded(child: _Stat(value: '05', label: 'SEMESTER')),
          _VerticalLine(),
          Expanded(child: _Stat(value: '03', label: 'YEAR')),
        ],
      ),
    );
  }

  Widget _campusServices() {
    return Column(
      children: [
        _wideLink(
          Icons.local_library_outlined,
          'Library',
          'Study spaces, books and learning resources',
              () => _openPage('LIBRARY', _libraryContent()),
        ),
        _wideLink(
          Icons.support_agent_outlined,
          'Student Service Centre',
          'Submit a campus service request',
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentServiceFormPage(),
              ),
            );
          },
        ),
        _wideLink(
          Icons.science_outlined,
          'Science',
          'Scientific activity of the University',
              () => _openPage('SCIENCE', _scienceContent()),
        ),
      ],
    );
  }

  Widget _wideLink(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE3E3E3))),
        ),
        child: Row(
          children: [
            Icon(icon, color: iituRed, size: 28),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _events() {
    return Column(
      children: [
        _eventRow('05', 'OCT', 'Cybersecurity Workshop', '14:00',
            Icons.security_outlined),
        _eventRow('10', 'OCT', 'Student Life Fair', '14:00',
            Icons.groups_outlined),
        _eventRow('18', 'OCT', 'The Last NOT Late Night Show', '18:00',
            Icons.celebration_outlined),
      ],
    );
  }

  Widget _eventRow(
      String day, String month, String title, String time, IconData icon) {
    return InkWell(
      onTap: () => _showMessage('$title selected'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(18),
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 55,
              child: Column(
                children: [
                  Text(day,
                      style: const TextStyle(
                          color: iituRed,
                          fontSize: 25,
                          fontWeight: FontWeight.w900)),
                  Text(month,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            Text(time, style: const TextStyle(color: Colors.black54)),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_outward, size: 18),
          ],
        ),
      ),
    );
  }

  // ======================== SCHEDULE ========================

  Widget _buildSchedulePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SCHEDULE',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.5)),
              const SizedBox(height: 6),
              const Text('Your classes for this week',
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 28),
              _day('MONDAY', [
                ['Organization of Database Management Systems. L', '14:10 - 15:00', 'Bazarbekov I', 'Main 301'],
                ['Authors Programs. L', '15:10 - 16:00', 'Shorokhov D', 'Main 604'],
                ['Authors Programs. PS', '16:10 - 18:10', 'Shorokhov D', 'Main 207'],
              ]),
              _day('TUESDAY', [
                ['Artificial Intelligence in Cybersecurity', '14:00 - 16:00', 'Akhmed G.Z', 'Main 607'],
                ['Cryptographic Methods of Information Security', '16:10 - 18:00', 'V.V', 'Online'],
              ]),
              _day('WEDNESDAY', [
                ['Philosophy', '12:10 - 13:00', 'Batayeva S.A', 'Bayzak 216B'],
              ]),
              _day('THURSDAY', [
                ['Organization and architecture of computing systems. L', '11:00 - 11:50', 'Pustovoi E', 'Bayzak 304B'],
                ['Design Pattern. L', '12:10 - 13:00', 'V.V', 'Bayzak 216B'],
              ]),
              _day('FRIDAY', [
                ['Cryptographic Methods of Information Security. L', '19:30 - 20:20', 'Ashraf O', 'Main 422'],
                ['Philosophy', '20:30 - 21:20', 'Begalinov A', 'Online'],
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _day(String title, List<List<String>> subjects) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: iituRed,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.3)),
          const SizedBox(height: 10),
          ...subjects.map((s) => _subjectCard(s[0], s[1], s[2], s[3])),
        ],
      ),
    );
  }

  Widget _subjectCard(
      String subject, String time, String teacher, String room) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: iituRed, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(time,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: iituRed)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                Text('$teacher  •  $room',
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================== PROFILE ========================

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 100),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                color: iituDark,
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: iituRed),
                    ),
                    SizedBox(width: 22),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tussupova Dariya',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900)),
                          SizedBox(height: 5),
                          Text('6B06301 • Computer Security',
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Text('GPA\n3.0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _profileItem(Icons.badge_outlined, 'Student ID', '436798'),
              _profileItem(Icons.school_outlined, 'Degree Programme',
                  '6B06301 - Computer Security'),
              _profileItem(Icons.calendar_today_outlined, 'Course', '3'),
              _profileItem(
                  Icons.email_outlined, 'Email', 'student@iitu.edu.kz'),
              _profileItem(Icons.check_circle_outline, 'Status', 'Active Student'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileItem(IconData icon, String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(18),
      color: Colors.white,
      child: Row(
        children: [
          Icon(icon, color: iituRed),
          const SizedBox(width: 16),
          SizedBox(
            width: 150,
            child: Text(title,
                style: const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  // ======================== DETAIL PAGE CONTENT ========================

  Widget _facultiesContent() {
    return Column(
      children: [
        _infoCard(
          '01',
          'Computer Technologies and Cybersecurity',
          'Study programmes related to information technology, software, computing and cybersecurity.',
          Icons.computer_outlined,
        ),
        _infoCard(
          '02',
          'Business, Media and Management',
          'Study programmes combining technology with business, management and media.',
          Icons.business_center_outlined,
        ),
      ],
    );
  }

  Widget _clubsContent() {
    return Column(
      children: [
        _infoCard('01', 'Shadows',
            'Dance ensemble created to popularize the culture and traditions of various dance styles.', Icons.groups),
        _infoCard('02', 'OSIT ',
            'Student organization dedicated to build a strong IT community.', Icons.code),
        _infoCard('03', 'SIRIUS',
            'Sports organization promoting healthy by creating sport tournaments.', Icons.groups),
      ],
    );
  }

  Widget _campusContent() {
    return Column(
      children: [
        _infoCard('01', 'Main Campus', 'International IT University • Almaty, Kazakhstan',
            Icons.account_balance_outlined),
        _infoCard('02', 'Study Spaces',
            'Classrooms, computer laboratories and student study areas.',
            Icons.laptop_mac_outlined),
        _infoCard('03', 'Campus Services',
            'Library, student support and other university services.',
            Icons.location_city_outlined),
      ],
    );
  }

  Widget _contactsContent() {
    return Column(
      children: [
        _infoCard('01', 'Student Support',
            'Contact the university student support team for campus-related questions.',
            Icons.support_agent),
        _infoCard('02', 'Campus Email', 'student@iitu.edu.kz',
            Icons.email_outlined),
        _infoCard('03', 'Location', 'Almaty, Kazakhstan',
            Icons.location_on_outlined),
      ],
    );
  }

  Widget _noticesContent() {
    return Column(
      children: [
        _infoCard('NEW', 'Academic Reminder',
            'Check your weekly schedule and university announcements regularly.',
            Icons.campaign_outlined),
        _infoCard('05 OCT', 'Cybersecurity Workshop',
            'Workshop starts at 14:00.', Icons.security_outlined),
        _infoCard('10 OCT', 'Student Life Fair',
            'Student Life Fair starts at 14:00.', Icons.groups_outlined),
      ],
    );
  }

  Widget _libraryContent() {
    return Column(
      children: [
        _infoCard('01', 'Learning Resources',
            'Access books and learning materials for your studies.',
            Icons.menu_book_outlined),
        _infoCard('02', 'Study Space',
            'Use university study areas for individual or group work.',
            Icons.chair_alt_outlined),
      ],
    );
  }


  Widget _scienceContent() {
    return Column(
      children: [
        _infoCard('01', 'Research & Science',
            'Explore scientific activity and research opportunities at the university.',
            Icons.science_outlined),
        _infoCard('02', 'Student Projects',
            'Discover opportunities to participate in academic and technology projects.',
            Icons.lightbulb_outline),
      ],
    );
  }

  Widget _helpContent() {
    return Column(
      children: [
        _infoCard('01', 'Student Help',
            'Use Student Service Centre for university-related support.',
            Icons.help_outline),
        _infoCard('02', 'Technical Support',
            'Get assistance with campus digital services.',
            Icons.computer_outlined),
      ],
    );
  }

  Widget _infoCard(
      String label, String title, String description, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(22),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            child: Text(
              label,
              style: const TextStyle(
                color: iituRed,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Icon(icon, size: 30, color: iituDark),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 19, fontWeight: FontWeight.w900)),
                const SizedBox(height: 7),
                Text(description,
                    style: const TextStyle(
                        color: Colors.black54, height: 1.45)),
              ],
            ),
          ),
          const Icon(Icons.arrow_outward, size: 18, color: Colors.black38),
        ],
      ),
    );
  }
}
// Timetable is a separate route opened through Navigator.
class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        title: const Text(
          'MY SCHEDULE',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 60),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'SCHEDULE',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Your classes for this week',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 28),

                _RouteDay(
                  day: 'MONDAY',
                  subjects: [
                    ['Organization of Database Management Systems. L', '14:10 - 15:00', 'Bazarbekov I', 'Main 301'],
                    ['Authors Programs. L', '15:10 - 16:00', 'Shorokhov D', 'Main 604'],
                    ['Authors Programs. PS', '16:10 - 18:10', 'Shorokhov D', 'Main 207'],
                  ],
                ),

                _RouteDay(
                  day: 'TUESDAY',
                  subjects: [
                    ['Artificial Intelligence in Cybersecurity', '14:00 - 16:00', 'Akhmed G.Z', 'Main 607'],
                    ['Cryptographic Methods of Information Security', '16:10 - 18:00', 'V.V', 'Online'],
                  ],
                ),

                _RouteDay(
                  day: 'WEDNESDAY',
                  subjects: [
                    ['Philosophy', '12:10 - 13:00', 'Batayeva S.A', 'Bayzak 216B'],
                  ],
                ),

                _RouteDay(
                  day: 'THURSDAY',
                  subjects: [
                    ['Organization and architecture of computing systems. L', '11:00 - 11:50', 'Pustovoi E', 'Bayzak 304B'],
                    ['Design Pattern. L', '12:10 - 13:00', 'V.V', 'Bayzak 216B'],
                  ],
                ),

                _RouteDay(
                  day: 'FRIDAY',
                  subjects: [
                    ['Cryptographic Methods of Information Security. L', '19:30 - 20:20', 'Ashraf O', 'Main 422'],
                    ['Philosophy', '20:30 - 21:20', 'Begalinov A', 'Online'],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _RouteDay extends StatelessWidget {
  final String day;
  final List<List<String>> subjects;

  const _RouteDay({
    required this.day,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: const TextStyle(
              color: iituRed,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          ...subjects.map(
                (subject) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: iituRed, width: 4),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      subject[1],
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: iituRed,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject[0],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          '${subject[2]}  •  ${subject[3]}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Stores information about one campus service.
class CampusService {
  final String name;
  final String description;
  final String location;
  final String hours;
  final String contact;

  const CampusService({
    required this.name,
    required this.description,
    required this.location,
    required this.hours,
    required this.contact,
  });
}
// Fallback screen for an unknown or incorrect route.
class UnknownRouteScreen extends StatelessWidget {
  final String routeName;

  const UnknownRouteScreen({
    super.key,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        title: const Text(
          'PAGE NOT FOUND',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: iituRed,
              ),
              const SizedBox(height: 20),
              const Text(
                '404',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Page not found',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Unknown route: $routeName',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('GO BACK'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: iituRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Student Profile is a separate named route.
class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        title: const Text(
          'STUDENT PROFILE',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 60),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundColor: iituRed,
                  child: Icon(
                    Icons.person_outline,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Student Profile',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),

                const Text(
                  'International IT University',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),

                _profileInfo(
                  Icons.badge_outlined,
                  'Student ID',
                  'Student Account',
                ),
                _profileInfo(
                  Icons.school_outlined,
                  'Programme',
                  'Computer Security',
                ),
                _profileInfo(
                  Icons.email_outlined,
                  'Email',
                  'student@iitu.edu.kz',
                ),
                _profileInfo(
                  Icons.location_city_outlined,
                  'University',
                  'International IT University',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileInfo(
      IconData icon,
      String title,
      String value,
      ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      color: Colors.white,
      child: Row(
        children: [
          Icon(icon, color: iituRed),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
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
// Stores information about one campus event.
class CampusEvent {
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;

  const CampusEvent({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
  });
}
// Campus Events is a separate named route.
class CampusEventsScreen extends StatelessWidget {
  const CampusEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        title: const Text(
          'CAMPUS EVENTS',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 60),
        children: const [
          Text(
            'UPCOMING EVENTS',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Discover what is happening around campus.',
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 25),

          _CampusEventCard(
            date: '10 OCT',
            title: 'Student Club Fair',
            location: 'Main Hall',
            time: '12:00 - 15:00',
            event: CampusEvent(
              title: 'Student Club Fair',
              date: '10 OCT',
              time: '12:00 - 15:00',
              location: 'Main Hall',
              description:
              'Meet student clubs, discover campus activities and find new opportunities to participate in university life.',
            ),
          ),

          _CampusEventCard(
            date: '15 OCT',
            title: 'Cybersecurity Workshop',
            location: 'Computer Lab',
            time: '14:00 - 16:00',
            event: CampusEvent(
              title: 'Cybersecurity Workshop',
              date: '15 OCT',
              time: '14:00 - 16:00',
              location: 'Computer Lab',
              description:
              'A practical workshop where students can learn more about cybersecurity concepts, tools and current security challenges.',
            ),
          ),

          _CampusEventCard(
            date: '22 OCT',
            title: 'University Sports Day',
            location: 'Sports Centre',
            time: '10:00 - 17:00',
            event: CampusEvent(
              title: 'Sirius Day',
              date: '22 OCT',
              time: '10:00 - 17:00',
              location: 'Sports Centre',
              description:
              'A university sports event with activities, competitions and opportunities for students to spend time together.',
            ),
          ),
        ],
      ),
    );
  }
}
// Displays full information about the selected campus event.
class EventDetailScreen extends StatelessWidget {
  final CampusEvent event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        title: const Text(
          'EVENT DETAILS',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.date,
              style: const TextStyle(
                color: iituRed,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              event.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 24),

            _eventInfo(
              Icons.access_time,
              'Time',
              event.time,
            ),
            _eventInfo(
              Icons.location_on_outlined,
              'Location',
              event.location,
            ),

            const SizedBox(height: 22),

            const Text(
              'ABOUT THIS EVENT',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              event.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventInfo(
      IconData icon,
      String title,
      String value,
      ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Icon(icon, color: iituRed),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _CampusEventCard extends StatelessWidget {
  final String date;
  final String title;
  final String location;
  final String time;
  final CampusEvent event;

  const _CampusEventCard({
    required this.date,
    required this.title,
    required this.location,
    required this.time,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // Opens event details using a direct MaterialPageRoute.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event),
            ),
          );
        },
        child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            alignment: Alignment.center,
            color: iituRed,
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '$time  •  $location',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
        ),
    );
  }
}
// Campus Services is a separate named route.
class CampusServicesScreen extends StatelessWidget {
  const CampusServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        title: const Text(
          'CAMPUS SERVICES',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            'STUDENT SERVICES',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Select a service to view more information.',
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 25),

          _CampusServiceTile(
            icon: Icons.computer_outlined,
            title: 'IT Support',
            subtitle: 'Technical and campus system support',
            service: CampusService(
              name: 'IT Support',
              description:
              'Provides technical support for university systems, student accounts, Wi-Fi and other IT-related issues.',
              location: 'Main Building, Room 105',
              hours: 'Monday - Friday, 09:00 - 18:00',
              contact: 'support@iitu.edu.kz',
            ),
          ),

          _CampusServiceTile(
            icon: Icons.school_outlined,
            title: 'Academic Support',
            subtitle: 'Help with academic and study-related questions',
            service: CampusService(
              name: 'Academic Support',
              description:
              'Provides support for students with academic questions, study planning and university learning processes.',
              location: 'Main Building, Room 203',
              hours: 'Monday - Friday, 09:00 - 17:00',
              contact: 'academic@iitu.edu.kz',
            ),
          ),

          _CampusServiceTile(
            icon: Icons.local_library_outlined,
            title: 'Library Services',
            subtitle: 'Books, learning resources and study spaces',
            service: CampusService(
              name: 'Library Services',
              description:
              'Provides access to books, digital learning resources and study spaces for students.',
              location: 'Main Building, Library',
              hours: 'Monday - Saturday, 08:00 - 20:00',
              contact: 'library@iitu.edu.kz',
            ),
          ),

          _CampusServiceTile(
            icon: Icons.groups_outlined,
            title: 'Student Affairs',
            subtitle: 'Student activities and campus support',
            service: CampusService(
              name: 'Student Affairs',
              description:
              'Supports students with campus activities, student organisations and general university life.',
              location: 'Main Building, Room 110',
              hours: 'Monday - Friday, 09:00 - 18:00',
              contact: 'studentaffairs@iitu.edu.kz',
            ),
          ),
        ],
      ),
    );
  }
}

// Shows full information about the selected campus service.
class ServiceDetailScreen extends StatelessWidget {
  final CampusService service;

  const ServiceDetailScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        title: const Text(
          'SERVICE DETAILS',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              service.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 28),

            _detailRow(
              Icons.location_on_outlined,
              'Location',
              service.location,
            ),
            _detailRow(
              Icons.access_time,
              'Opening Hours',
              service.hours,
            ),
            _detailRow(
              Icons.contact_support_outlined,
              'Contact',
              service.contact,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Returns a result to the previous screen after the service request.
                  Navigator.pop(context, 'requested');
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('REQUEST SERVICE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: iituRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Icon(icon, color: iituRed),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
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
class _CampusServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final CampusService service;

  const _CampusServiceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Colors.white,
        contentPadding: const EdgeInsets.all(18),
        leading: Icon(icon, color: iituRed, size: 30),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () async {
          // Passes the selected service object to the details screen.
          final result = await Navigator.pushNamed(
            context,
            AppRoutes.serviceDetail,
            arguments: service,
          );
// Shows visible feedback when a result is returned from the details screen.
          if (result == 'requested' && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${service.name} request submitted successfully!',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _VerticalLine extends StatelessWidget {
  const _VerticalLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 55,
      color: Colors.white24,
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final Widget child;

  const DetailPage({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(width: 55, height: 4, color: iituRed),
                const SizedBox(height: 28),
                child,
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class StudentServiceFormPage extends StatefulWidget {
  const StudentServiceFormPage({super.key});

  @override
  State<StudentServiceFormPage> createState() =>
      _StudentServiceFormPageState();
}

class _StudentServiceFormPageState extends State<StudentServiceFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _detailsController = TextEditingController();

  String? _selectedCategory;
  String? _selectedUrgency;
  String? _preferredContact;
  DateTime? _preferredDate;
  bool _acceptedDeclaration = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: iituRed,
        foregroundColor: Colors.white,
        title: const Text(
          'STUDENT SERVICE CENTRE',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CAMPUS SERVICE REQUEST',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      width: 55,
                      height: 4,
                      color: iituRed,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Complete the form below to contact a campus service unit.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 35),

                    const Text(
                      'STUDENT DETAILS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // STUDENT NAME
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Student Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }

                        if (value.trim().split(' ').length < 2) {
                          return 'Please enter at least two names';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // STUDENT ID
                    TextFormField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Student ID',
                        hintText: 'Example: 436798',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your Student ID';
                        }

                        if (!RegExp(r'^[0-9]{6,}$').hasMatch(value.trim())) {
                          return 'Student ID must contain at least 6 digits';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // CAMPUS EMAIL
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Campus Email',
                        hintText: 'student@iitu.edu.kz',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your campus email';
                        }

                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email address';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    // PHONE NUMBER
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+7 700 000 0000',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final phone = value.replaceAll(' ', '');

                          if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(phone)) {
                            return 'Please enter a valid phone number';
                          }
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      'REQUEST DETAILS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 18),

// SERVICE CATEGORY
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Service Category',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select a service'),
                      items: const [
                        DropdownMenuItem(
                          value: 'IT Support',
                          child: Text('IT Support'),
                        ),
                        DropdownMenuItem(
                          value: 'Academic Support',
                          child: Text('Academic Support'),
                        ),
                        DropdownMenuItem(
                          value: 'Library Services',
                          child: Text('Library Services'),
                        ),
                        DropdownMenuItem(
                          value: 'Student Affairs',
                          child: Text('Student Affairs'),
                        ),
                        DropdownMenuItem(
                          value: 'Campus Facilities',
                          child: Text('Campus Facilities'),
                        ),
                        DropdownMenuItem(
                          value: 'Career Services',
                          child: Text('Career Services'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a service category';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

// REQUEST SUBJECT
                    TextFormField(
                      controller: _subjectController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Request Subject',
                        hintText: 'Briefly describe your request',
                        prefixIcon: Icon(Icons.title_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a request subject';
                        }

                        if (value.trim().length < 5) {
                          return 'Subject must contain at least 5 characters';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

// REQUEST DETAILS
                    TextFormField(
                      controller: _detailsController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      maxLength: 300,
                      decoration: const InputDecoration(
                        labelText: 'Request Details',
                        hintText: 'Describe your request in more detail...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 80),
                          child: Icon(Icons.description_outlined),
                        ),
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please describe your request';
                        }

                        if (value.trim().length < 20) {
                          return 'Please enter at least 20 characters';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 30),



// URGENCY
                    const Text(
                      'URGENCY',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    FormField<String>(
                      validator: (value) {
                        if (_selectedUrgency == null) {
                          return 'Please select urgency';
                        }
                        return null;
                      },
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 10,
                              children: ['Normal', 'Soon', 'Urgent'].map((level) {
                                return ChoiceChip(
                                  label: Text(level),
                                  selected: _selectedUrgency == level,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedUrgency = level;
                                    });
                                    field.didChange(level);
                                  },
                                );
                              }).toList(),
                            ),
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  field.errorText!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 35),

                    const Text(
                      'PREFERENCES',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 18),

// PREFERRED CONTACT
                    const Text(
                      'Preferred Contact Method',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    FormField<String>(
                      validator: (value) {
                        if (_preferredContact == null) {
                          return 'Please select a contact method';
                        }
                        return null;
                      },
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 10,
                              children: ['Email', 'Phone'].map((method) {
                                return ChoiceChip(
                                  label: Text(method),
                                  selected: _preferredContact == method,
                                  onSelected: (selected) {
                                    setState(() {
                                      _preferredContact = method;
                                    });
                                    field.didChange(method);
                                  },
                                );
                              }).toList(),
                            ),
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  field.errorText!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

// PREFERRED DATE
                    FormField<DateTime>(
                      validator: (value) {
                        if (_preferredDate == null) {
                          return 'Please select a preferred date';
                        }

                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);

                        if (_preferredDate!.isBefore(today)) {
                          return 'Preferred date cannot be in the past';
                        }

                        return null;
                      },
                      builder: (field) {
                        return InkWell(
                          onTap: () async {
                            final now = DateTime.now();
                            final today = DateTime(now.year, now.month, now.day);

                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _preferredDate ?? today,
                              firstDate: today,
                              lastDate: DateTime(
                                now.year + 1,
                                now.month,
                                now.day,
                              ),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                _preferredDate = pickedDate;
                              });

                              field.didChange(pickedDate);
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Preferred Date',
                              prefixIcon: const Icon(Icons.calendar_today_outlined),
                              border: const OutlineInputBorder(),
                              errorText: field.errorText,
                            ),
                            child: Text(
                              _preferredDate == null
                                  ? 'Select a date'
                                  : '${_preferredDate!.day.toString().padLeft(2, '0')}/'
                                  '${_preferredDate!.month.toString().padLeft(2, '0')}/'
                                  '${_preferredDate!.year}',
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 35),

// CONFIRMATION
                    const Text(
                      'CONFIRMATION',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 12),

                    FormField<bool>(
                      validator: (value) {
                        if (!_acceptedDeclaration) {
                          return 'Please confirm the declaration';
                        }
                        return null;
                      },
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: _acceptedDeclaration,
                              title: const Text(
                                'I confirm that the information provided is correct.',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _acceptedDeclaration = value ?? false;
                                });
                                field.didChange(_acceptedDeclaration);
                              },
                            ),
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  field.errorText!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _submitForm,
                            icon: const Icon(Icons.send_outlined),
                            label: const Text('SUBMIT REQUEST'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: iituRed,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resetForm,
                            icon: const Icon(Icons.refresh),
                            label: const Text('RESET'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: iituRed),
                SizedBox(width: 10),
                Text('Request Submitted'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your campus service request has been submitted successfully.',
                  ),
                  const SizedBox(height: 20),

                  Text('Student: ${_nameController.text}'),
                  Text('Student ID: ${_idController.text}'),
                  Text('Service: $_selectedCategory'),
                  Text('Subject: ${_subjectController.text}'),
                  Text('Urgency: $_selectedUrgency'),
                  Text('Contact: $_preferredContact'),

                  if (_preferredDate != null)
                    Text(
                      'Date: ${_preferredDate!.day.toString().padLeft(2, '0')}/'
                          '${_preferredDate!.month.toString().padLeft(2, '0')}/'
                          '${_preferredDate!.year}',
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();

    _nameController.clear();
    _idController.clear();
    _emailController.clear();
    _phoneController.clear();
    _subjectController.clear();
    _detailsController.clear();

    setState(() {
      _selectedCategory = null;
      _selectedUrgency = null;
      _preferredContact = null;
      _preferredDate = null;
      _acceptedDeclaration = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form has been reset'),
      ),
    );
  }
  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
