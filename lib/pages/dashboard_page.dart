import 'package:flutter/material.dart';

const Color kMeroBlue = Color(0xFF673AB7);
const Color kMeroSubtitle = Color(0xFF8D8D8D);
const Color kMeroLightPurple = Color(0xFFF3E5F5);
const Color kMeroGradientStart = Color(0xFF7B1FA2);
const Color kMeroGradientEnd = Color(0xFF9575CD);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 30),
              _buildSearchBar(),
              const SizedBox(height: 25),
              _buildActionCards(),
              const SizedBox(height: 35),
              _buildSectionTitle('Discovery', onViewAll: () {}),
              const SizedBox(height: 15),
              _buildDiscoverySection(),
              const SizedBox(height: 35),
              _buildSectionTitle('Your Rooms', onViewAll: () {}),
              const SizedBox(height: 15),
              _buildRoomsSection(),
              const SizedBox(height: 35),
              _buildSectionTitle('Recent Activity', onViewAll: () {}),
              const SizedBox(height: 15),
              _buildRecentActivity(),
              const SizedBox(height: 30),
              _buildBottomStats(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kMeroBlue, width: 2),
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: kMeroLightPurple,
                child: Icon(Icons.person, color: kMeroBlue, size: 28),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Namaste,',
                  style: TextStyle(
                    fontSize: 14,
                    color: kMeroSubtitle,
                  ),
                ),
                Text(
                  'Nickname',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: kMeroBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _buildIconButton(Icons.notifications_outlined, () {}),
            const SizedBox(width: 8),
            _buildIconButton(Icons.settings_outlined, () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kMeroLightPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: kMeroBlue, size: 22),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search rooms, people, places...',
          hintStyle: TextStyle(color: kMeroSubtitle, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: kMeroBlue),
          suffixIcon: Icon(Icons.tune, color: kMeroSubtitle),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildActionCards() {
    return Column(
      children: [
        _buildGradientActionCard(
          icon: Icons.add_circle_outline,
          title: 'Create a Room',
          subtitle: 'Start a new decision with friends',
          gradientColors: [kMeroGradientStart, kMeroGradientEnd],
          onTap: () {},
        ),
        const SizedBox(height: 15),
        _buildGradientActionCard(
          icon: Icons.qr_code_scanner,
          title: 'Join with Code',
          subtitle: 'Enter a code to join a room',
          gradientColors: [const Color(0xFF26A69A), const Color(0xFF80CBC4)],
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildGradientActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.8), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {required VoidCallback onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kMeroBlue,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            'View All',
            style: TextStyle(
              fontSize: 14,
              color: kMeroBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoverySection() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildDiscoveryCard(
            image: 'assets/momos.png',
            title: 'New Road Momos',
            subtitle: '15 people deciding',
            badgeText: 'NEW',
            badgeColor: Colors.green,
            isLive: true,
          ),
          const SizedBox(width: 15),
          _buildDiscoveryCard(
            image: 'assets/movies.png',
            title: 'Friday Blockbusters',
            subtitle: '28 people deciding',
            badgeText: 'TRENDING',
            badgeColor: Colors.red,
            isLive: false,
          ),
          const SizedBox(width: 15),
          _buildDiscoveryCard(
            image: 'assets/coffee.png',
            title: 'Coffee Meetup',
            subtitle: '8 people deciding',
            badgeText: 'HOT',
            badgeColor: Colors.orange,
            isLive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveryCard({
    required String image,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required bool isLive,
  }) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kMeroLightPurple, Colors.grey[200]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Icon(Icons.restaurant, size: 40, color: kMeroBlue.withOpacity(0.3)),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isLive)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: kMeroSubtitle,
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

  Widget _buildRoomsSection() {
    return Column(
      children: [
        _buildRoomCard(
          title: 'Weekend Plans',
          participants: 8,
          status: 'Voting',
          timeLeft: '2h left',
          category: 'Social',
        ),
        const SizedBox(height: 12),
        _buildRoomCard(
          title: 'Lunch Spot Today',
          participants: 12,
          status: 'Results',
          timeLeft: 'Ended',
          category: 'Food',
        ),
      ],
    );
  }

  Widget _buildRoomCard({
    required String title,
    required int participants,
    required String status,
    required String timeLeft,
    required String category,
  }) {
    final bool isActive = status == 'Voting';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? kMeroBlue.withOpacity(0.2) : Colors.grey[200]!,
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive ? kMeroBlue.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kMeroLightPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  color: kMeroBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.people, size: 14, color: kMeroSubtitle),
                        const SizedBox(width: 4),
                        Text(
                          '$participants participants',
                          style: TextStyle(
                            fontSize: 12,
                            color: kMeroSubtitle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isActive ? kMeroBlue : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeLeft,
                    style: TextStyle(
                      fontSize: 11,
                      color: kMeroSubtitle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isActive) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 0.7,
                backgroundColor: kMeroLightPurple,
                valueColor: AlwaysStoppedAnimation<Color>(kMeroBlue),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Social':
        return Icons.groups;
      case 'Movies':
        return Icons.movie;
      default:
        return Icons.category;
    }
  }

  Widget _buildRecentActivity() {
    return Column(
      children: [
        _buildActivityTile(
          icon: Icons.restaurant,
          title: 'Burger House',
          subtitle: 'Match • 2 days ago',
          hasAction: true,
        ),
        const SizedBox(height: 12),
        _buildActivityTile(
          icon: Icons.movie_creation_outlined,
          title: 'FCUBE Cinemas',
          subtitle: 'Match • Yesterday',
          hasAction: true,
        ),
        const SizedBox(height: 12),
        _buildActivityTile(
          icon: Icons.coffee,
          title: 'Java Coffee',
          subtitle: 'Match • 4 days ago',
          hasAction: false,
        ),
      ],
    );
  }

  Widget _buildActivityTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool hasAction,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kMeroLightPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: kMeroBlue, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: kMeroSubtitle,
                  ),
                ),
              ],
            ),
          ),
          if (hasAction)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kMeroBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.replay,
                color: kMeroBlue,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kMeroLightPurple, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('42', 'Students Choosing'),
          Container(width: 1, height: 40, color: kMeroBlue.withOpacity(0.2)),
          _buildStatItem('15', 'Active Rooms'),
          Container(width: 1, height: 40, color: kMeroBlue.withOpacity(0.2)),
          _buildStatItem('128', 'Matches Made'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: kMeroBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: kMeroSubtitle,
          ),
        ),
      ],
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: kMeroBlue,
      elevation: 6,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, Icons.home_outlined, 'Home'),
              _buildNavItem(1, Icons.groups, Icons.groups_outlined, 'Rooms'),
              const SizedBox(width: 50),
              _buildNavItem(2, Icons.history, Icons.history_outlined, 'Matches'),
              _buildNavItem(3, Icons.person, Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kMeroLightPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? kMeroBlue : kMeroSubtitle,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? kMeroBlue : kMeroSubtitle,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
