// import 'package:flutter/material.dart';

// class Profile extends StatelessWidget {
//   const Profile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//           child: Column(
//             children: [
//               // Profile Image
//               Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   CircleAvatar(
//                     radius: 70,
//                     backgroundImage: NetworkImage(
//                       'https://i.pravatar.cc/300',
//                     ),
//                   ),
//                   Positioned(
//                     right: 8,
//                     bottom: 8,
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.deepPurple,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Section: Account
//               const SectionTitle(title: "Account"),
//               const ProfileItem(icon: Icons.person, title: "Edit profile"),
//               const ProfileItem(icon: Icons.notifications, title: "Notifications"),
//               const ProfileItem(icon: Icons.lock, title: "Privacy"),

//               const SizedBox(height: 20),
//               const SectionTitle(title: "Support & About"),
//               const ProfileItem(icon: Icons.subscriptions, title: "My Subscription"),
//               const ProfileItem(icon: Icons.help_outline, title: "Help & Support"),
//               const ProfileItem(icon: Icons.info_outline, title: "Terms and Policies"),

//               const SizedBox(height: 20),
//               const SectionTitle(title: "Actions"),
//               const ProfileItem(icon: Icons.flag, title: "Report a problem"),
//               const ProfileItem(icon: Icons.group_add, title: "Add account"),
//               const ProfileItem(icon: Icons.logout, title: "Log out"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SectionTitle extends StatelessWidget {
//   final String title;

//   const SectionTitle({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
//       ),
//     );
//   }
// }

// class ProfileItem extends StatelessWidget {
//   final IconData icon;
//   final String title;

//   const ProfileItem({super.key, required this.icon, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 0),
//       leading: Icon(icon, color: Colors.black87),
//       title: Text(title),
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => Scaffold(
//               appBar: AppBar(title: Text(title)),
//               body: Center(child: Text('This is the $title page')),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login.dart';

// class Profile extends StatefulWidget {
//   const Profile({super.key});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   String? username;
//   String? avatar;
//   bool isLoggedIn = false;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     checkLoginStatus();
//   }

//   Future<void> checkLoginStatus() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final user = prefs.getString('username');
//       final image = prefs.getString('avatar');

//       if (user != null) {
//         setState(() {
//           username = user;
//           avatar = image;
//           isLoggedIn = true;
//         });
//       }
//     } catch (e) {
//       debugPrint('SharedPreferences error: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (!isLoggedIn) {
//       return Scaffold(
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
//             },
//             child: const Text('Please Login'),
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//           child: Column(
//             children: [
//               Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   CircleAvatar(
//                     radius: 70,
//                     backgroundImage: avatar != null
//                         ? NetworkImage(avatar!)
//                         : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
//                   ),
//                   Positioned(
//                     right: 8,
//                     bottom: 8,
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: const BoxDecoration(
//                         color: Colors.deepPurple,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Text(username ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 20),
//               const SectionTitle(title: "Account"),
//               const ProfileItem(icon: Icons.person, title: "Edit profile"),
//               const ProfileItem(icon: Icons.notifications, title: "Notifications"),
//               const ProfileItem(icon: Icons.lock, title: "Privacy"),
//               const SizedBox(height: 20),
//               const SectionTitle(title: "Support & About"),
//               const ProfileItem(icon: Icons.subscriptions, title: "My Subscription"),
//               const ProfileItem(icon: Icons.help_outline, title: "Help & Support"),
//               const ProfileItem(icon: Icons.info_outline, title: "Terms and Policies"),
//               const SizedBox(height: 20),
//               const SectionTitle(title: "Actions"),
//               const ProfileItem(icon: Icons.flag, title: "Report a problem"),
//               const ProfileItem(icon: Icons.group_add, title: "Add account"),
//               const ProfileItem(icon: Icons.logout, title: "Log out"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SectionTitle extends StatelessWidget {
//   final String title;

//   const SectionTitle({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
//       ),
//     );
//   }
// }

// class ProfileItem extends StatelessWidget {
//   final IconData icon;
//   final String title;

//   const ProfileItem({super.key, required this.icon, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 0),
//       leading: Icon(icon, color: Colors.black87),
//       title: Text(title),
//       onTap: () {},
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? username;
  String? avatar;
  bool isLoggedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('username');
    final image = prefs.getString('avatar');

    if (user != null) {
      setState(() {
        username = user;
        avatar = image;
        isLoggedIn = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!isLoggedIn) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
          child: const Text('Please Login'),
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: avatar != null
                      ? NetworkImage(avatar!)
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(username ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const SectionTitle(title: "Account"),
            const ProfileItem(icon: Icons.person, title: "Edit profile"),
            const ProfileItem(icon: Icons.notifications, title: "Notifications"),
            const ProfileItem(icon: Icons.lock, title: "Privacy"),
            const SizedBox(height: 20),
            const SectionTitle(title: "Support & About"),
            const ProfileItem(icon: Icons.subscriptions, title: "My Subscription"),
            const ProfileItem(icon: Icons.help_outline, title: "Help & Support"),
            const ProfileItem(icon: Icons.info_outline, title: "Terms and Policies"),
            const SizedBox(height: 20),
            const SectionTitle(title: "Actions"),
            const ProfileItem(icon: Icons.flag, title: "Report a problem"),
            const ProfileItem(icon: Icons.group_add, title: "Add account"),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              leading: const Icon(Icons.logout, color: Colors.black87),
              title: const Text("Log out"),
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Icon(icon, color: Colors.black87),
      title: Text(title),
      onTap: () {},
    );
  }
}
