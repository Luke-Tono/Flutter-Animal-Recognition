import 'package:flutter/material.dart';

class ChromeBrowserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.account_circle, color: Colors.grey),
          onPressed: () {
            Navigator.pushNamed(context, '/image_recognition');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Google Logo
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Google',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontFamily: 'Arial',
                  ),
                ),
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onSubmitted: (query) {
                  Navigator.pushNamed(
                    context,
                    '/search_result',
                    arguments: query,
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.mic),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Quick Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickActionButton(
                    icon: Icons.language,
                    label: 'Translate',
                    color: Colors.orange,
                  ),
                  _buildQuickActionButton(
                    icon: Icons.star,
                    label: 'Favorites',
                    color: Colors.blue,
                  ),
                  _buildQuickActionButton(
                    icon: Icons.school,
                    label: 'Learning',
                    color: Colors.green,
                  ),
                  _buildQuickActionButton(
                    icon: Icons.music_note,
                    label: 'Music',
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Weather Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.cloud, size: 40, color: Colors.blue),
                  title: Text('Hamilton'),
                  subtitle: Text('Mostly cloudy, 21°C'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud, color: Colors.grey),
                      Text('20%'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // News Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top Stories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildNewsCard(
                    imageUrl: 'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/BB1msMpz.img',
                    title:
                    'NASA Says More Aurora Borealis Nights Are Coming Soon',
                    source: 'CNET - 6d',
                  ),
                  SizedBox(height: 10),
                  _buildNewsCard(
                    imageUrl:
                    'https://th.bing.com/th?id=OVFT.rl5-u7ypwxMnCx7411c5Ry&w=196&h=98&c=7&rs=1&qlt=80&o=6&dpr=1.5&pid=News',
                    title:
                    'How Artificial Intelligence is Shaping Our World',
                    source: 'TechCrunch - 2d',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildQuickActionButton(
      {required IconData icon, required String label, required Color color}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, size: 30, color: color),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildNewsCard(
      {required String imageUrl, required String title, required String source}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  source,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



