import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Alerts History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sos_alerts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var alerts = snapshot.data!.docs;

          if (alerts.isEmpty) return const Center(child: Text("No alerts found."));

          return ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              var alert = alerts[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                title: Text(alert['emergencyType'] ?? 'Unknown Emergency'),
                subtitle: Text("By: ${alert['senderName'] ?? 'Anonymous'}"),
                trailing: Text(
                  (alert['createdAt'] as Timestamp?)?.toDate().toString().substring(11, 16) ?? '',
                ),
              );
            },
          );
        },
      ),
    );
  }
}