import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../controller/home_controller.dart';

class UsersListScreen extends GetView<HomeController> {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bg,
      appBar: AppBar(
        title: Text("User Directory", style: TextStyle(color: context.appColors.gold)),
        backgroundColor: context.appColors.surf,
        elevation: 1,
        iconTheme: IconThemeData(color: context.appColors.gold),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: context.appColors.gold));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading users.", style: TextStyle(color: context.appColors.txt3)));
          }
          
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(child: Text("No users found.", style: TextStyle(color: context.appColors.txt3)));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final uid = docs[index].id;
              
              final fullName = data['fullName'] as String? ?? 'Unknown User';
              final role = data['role'] as String? ?? 'user';
              final description = data['description'] as String? ?? '';
              final email = data['email'] as String? ?? 'No email';
              
              // Read avatar from nested profile map if we want, or fallback
              final profileMap = data['profile'] as Map<String, dynamic>?;
              final avatar = profileMap?['avatar'] as String? ?? '👤';

              return Obx(() {
                final stColors = context.appColors;
                final amIAdmin = controller.profile.value.role == 'admin';

                return InkWell(
                  onTap: amIAdmin ? () => _showRoleChangeSheet(context, uid, fullName, role) : null,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: stColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: role == 'admin' ? stColors.goldD : stColors.bdr),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 45, height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: stColors.card2,
                          ),
                          child: Text(avatar, style: const TextStyle(fontSize: 22)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      fullName, 
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: stColors.txt)
                                    ),
                                  ),
                                  if (role == 'admin')
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: stColors.gold, borderRadius: BorderRadius.circular(6)),
                                      child: Text("ADMIN", style: TextStyle(fontSize: 9, color: stColors.bg, fontWeight: FontWeight.bold)),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(email, style: TextStyle(fontSize: 12, color: stColors.txt3)),
                              if (description.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(description, style: TextStyle(fontSize: 13, color: stColors.txt2)),
                              ]
                            ],
                          ),
                        ),
                        if (amIAdmin)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.more_vert, color: stColors.txt3, size: 20),
                          ),
                      ],
                    ),
                  ),
                );
              });
            },
          );
        },
      ),
    );
  }

  void _showRoleChangeSheet(BuildContext context, String targetUid, String userName, String currentRole) {
    final colors = context.appColors;
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.surf,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Manage User", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.txt)),
            const SizedBox(height: 4),
            Text("Change role for $userName", style: TextStyle(fontSize: 14, color: colors.txt2)),
            const SizedBox(height: 24),
            
            ListTile(
              leading: Icon(Icons.shield, color: currentRole == 'admin' ? colors.gold : colors.txt3),
              title: Text("Admin", style: TextStyle(color: currentRole == 'admin' ? colors.gold : colors.txt)),
              trailing: currentRole == 'admin' ? Icon(Icons.check, color: colors.gold) : null,
              onTap: () async {
                Get.back(); // close sheet
                await FirebaseFirestore.instance.collection('users').doc(targetUid).set({
                  'role': 'admin'
                }, SetOptions(merge: true));
                Get.snackbar("Success", "$userName is now an Admin.", snackPosition: SnackPosition.BOTTOM);
              },
            ),
            Divider(color: colors.bdr),
            ListTile(
              leading: Icon(Icons.person, color: currentRole == 'user' ? colors.gold : colors.txt3),
              title: Text("User", style: TextStyle(color: currentRole == 'user' ? colors.gold : colors.txt)),
              trailing: currentRole == 'user' ? Icon(Icons.check, color: colors.gold) : null,
              onTap: () async {
                Get.back();
                await FirebaseFirestore.instance.collection('users').doc(targetUid).set({
                  'role': 'user'
                }, SetOptions(merge: true));
                Get.snackbar("Success", "$userName is now a normal User.", snackPosition: SnackPosition.BOTTOM);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
