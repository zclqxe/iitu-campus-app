import 'package:flutter/material.dart';

void main() {
  runApp(const MyCampusApp());
}

class MyCampusApp extends StatelessWidget {
  const MyCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'International IT University',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC62828),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      ),
      home: const CampusHomePage(),
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

  final List<String> _pageTitles = [
    'International IT University',
    'My Schedule',
    'My Profile',
  ];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: Text(
          _pageTitles[_currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFC62828),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showMessage('No new notifications');
            },
          ),
        ],
      ),

      // DRAWER
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFC62828),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.school,
                      size: 35,
                      color: Color(0xFFC62828),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'IITU Campus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Student Campus App',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _changePage(0);
              },
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text('My Schedule'),
              onTap: () {
                Navigator.pop(context);
                _changePage(1);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
                _changePage(2);
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.school_outlined),
              title: const Text('Faculties'),
              onTap: () {
                Navigator.pop(context);
                _showMessage('Faculties selected');
              },
            ),

            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('Student Clubs'),
              onTap: () {
                Navigator.pop(context);
                _showMessage('Student Clubs selected');
              },
            ),

            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help Centre'),
              onTap: () {
                Navigator.pop(context);
                _showMessage('Help Centre selected');
              },
            ),
          ],
        ),
      ),

      // MAIN PAGES
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomePage(),
          _buildSchedulePage(),
          _buildProfilePage(),
        ],
      ),

      // FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC62828),
        foregroundColor: Colors.white,
        tooltip: 'Add Reminder',
        onPressed: () {
          setState(() {
            _reminderCount++;
          });

          _showMessage(
            'Reminder added! Total: $_reminderCount',
          );
        },
        child: const Icon(Icons.add),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFC62828),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // =========================================================
  // HOME PAGE
  // =========================================================

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to IITU',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Your Digital Future Begins Here!',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          // UNIVERSITY BANNER
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [

                  // UNIVERSITY PHOTO
                  Image.asset(
                    'assets/images/muitiitu.jpg',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),


                  // SLIGHT DARKENING
                  Container(
                    color: Colors.black.withValues(alpha: 0.10),
                  ),

                  // RED GRADIENT ON THE LEFT
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color(0xFFC62828).withValues(alpha: 0.95),
                          const Color(0xFFC62828).withValues(alpha: 0.70),
                          const Color(0xFFC62828).withValues(alpha: 0.30),
                          Colors.transparent,
                        ],
                        stops: const [
                          0.0,
                          0.30,
                          0.60,
                          1.0,
                        ],
                      ),
                    ),
                  ),

                  // TEXT ON THE PHOTO
                  const Padding(
                    padding: EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.account_balance,
                          color: Colors.white,
                          size: 38,
                        ),

                        SizedBox(height: 10),

                        Text(
                          'International IT University',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 8),

                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 19,
                            ),

                            SizedBox(width: 5),

                            Text(
                              'Almaty, Kazakhstan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // QUICK ACCESS
          const Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _buildQuickAccess(
                  Icons.calendar_month_outlined,
                  'Schedule',
                      () {
                    _changePage(1);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAccess(
                  Icons.school_outlined,
                  'Faculties',
                      () {
                    _showMessage('Faculties selected');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAccess(
                  Icons.groups_outlined,
                  'Clubs',
                      () {
                    _showMessage('Student Clubs selected');
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildQuickAccess(
                  Icons.location_on_outlined,
                  'Campus',
                      () {
                    _showMessage('Campus information selected');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAccess(
                  Icons.phone_outlined,
                  'Contacts',
                      () {
                    _showMessage('Contacts selected');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAccess(
                  Icons.campaign_outlined,
                  'Notices',
                      () {
                    _showMessage('Notices selected');
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // CAMPUS SERVICES
          // ACADEMIC OVERVIEW
          const Text(
            'Academic Overview',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.school_outlined,
                        color: Color(0xFFD32F2F),
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '3.0',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'GPA',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        color: Color(0xFFD32F2F),
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '5',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Semester',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: Color(0xFFD32F2F),
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '3',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Year',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),
          const Text(
            'Campus Services',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildCampusService(
            Icons.local_library_outlined,
            'Library',
            'Study spaces, books and learning resources',
          ),

          _buildCampusService(
            Icons.support_agent_outlined,
            'Student Service Centre',
            'Support and information for students',
          ),

          _buildCampusService(
            Icons.book_online_outlined,
            'Science',
            'Scientific activity of the University',
          ),

          const SizedBox(height: 28),

          // ACTIVITIES
          const Text(
            'Upcoming Activities',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildActivityCard(
            'Cybersecurity Workshop',
            '5 October • 14:00',
            Icons.security_outlined,
          ),

          _buildActivityCard(
            'Student Life Fair',
            '10 October • 14:00',
            Icons.groups_outlined,
          ),

          _buildActivityCard(
            'The Last NOT Late Night Show',
            '18 October • 18:00',
            Icons.celebration_outlined,
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // =========================================================
  // SCHEDULE PAGE
  // =========================================================

  Widget _buildSchedulePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Schedule',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Your classes for this week',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 25),

          // MONDAY
          _buildDayTitle('Monday'),

          _buildSubjectCard(
            'Organization of Database Management Systems. L',
            '14:10 - 15:00',
            'Bazarbekov I',
            'Main 301',
          ),

          _buildSubjectCard(
            'Authors Programs. L',
            '15:10 - 16:00',
            'Shorokhov D',
            'Main 604',
          ),

          _buildSubjectCard(
            'Authors Programs. PS',
            '16:10 - 18:10',
            'Shorokhov D',
            'Main 207',
          ),

          const SizedBox(height: 20),

          // TUESDAY
          _buildDayTitle('Tuesday'),

          _buildSubjectCard(
            'Artificial Intelligence in Cybersecurity',
            '14:00 - 16:00',
            'Akhmed G.Z',
            'Main 607',
          ),

          _buildSubjectCard(
            'Cryptogtraphic Methods of Information Security',
            '16:10 - 18:00',
            'V.V',
            'online',
          ),

          const SizedBox(height: 20),

          // WEDNESDAY
          _buildDayTitle('Wednesday'),

          _buildSubjectCard(
            'Philosophy',
            '12:10 - 13:00',
            'Batayeva S.A',
            'Bayzak 216B',
          ),


          const SizedBox(height: 20),

          // THURSDAY
          _buildDayTitle('Thursday'),

          _buildSubjectCard(
            'Organization and architecture of computing systems. L',
            '11:00 - 11:50',
            'Pustovoi E',
            'Bayzak 304B',
          ),

          _buildSubjectCard(
            'Design Pattern. L',
            '12:10 - 13:00',
            'V.V',
            'Bayzak 216B',
          ),

          const SizedBox(height: 20),

          // FRIDAY
          _buildDayTitle('Friday'),

          _buildSubjectCard(
            'Cryptographic Methods of Information Security. L',
            '19:30 - 20:20',
            'Ashraf O',
            'Main 422',
          ),

          _buildSubjectCard(
            'Philosophy',
            '20:30 - 21:20',
            'Begalinov A',
            'online',
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // =========================================================
  // PROFILE PAGE
  // =========================================================

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),

          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFFFFE5E5),
            child: Icon(
              Icons.person,
              size: 55,
              color: Color(0xFFC62828),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Student',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'GPA 3.0',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 30),

          _buildProfileItem(
            Icons.badge_outlined,
            'Student ID',
            '436798',
          ),

          _buildProfileItem(
            Icons.school_outlined,
            'Degree Programme',
            '6B06301 - Computer Security',
          ),

          _buildProfileItem(
            Icons.calendar_today_outlined,
            'Course',
            '3',
          ),

          _buildProfileItem(
            Icons.email_outlined,
            'Email',
            'student@iitu.edu.kz',
          ),

          _buildProfileItem(
            Icons.bar_chart_outlined,
            'Active',
            'Student',
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // =========================================================
  // REUSABLE WIDGETS
  // =========================================================

  Widget _buildDayTitle(String day) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        day,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFFC62828),
        ),
      ),
    );
  }

  Widget _buildQuickAccess(
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        height: 105,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color(0xFFC62828),
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampusService(
      IconData icon,
      String title,
      String description,
      ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE5E5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFC62828),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: () {
          _showMessage('$title selected');
        },
      ),
    );
  }

  Widget _buildActivityCard(
      String title,
      String date,
      IconData icon,
      ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFC62828),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(date),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: () {
          _showMessage('$title selected');
        },
      ),
    );
  }

  Widget _buildSubjectCard(
      String subject,
      String time,
      String teacher,
      String room,
      ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: const Border(
          left: BorderSide(
            color: Color(0xFFC62828),
            width: 5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 17,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(time),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 17,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(teacher),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 17,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(room),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(
      IconData icon,
      String title,
      String value,
      ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFC62828),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}