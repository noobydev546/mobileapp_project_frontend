import 'package:flutter/material.dart';

class AddEditDisableRooms extends StatefulWidget {
  const AddEditDisableRooms({super.key});

  @override
  State<AddEditDisableRooms> createState() => _AddEditDisableRoomsState();
}

class _AddEditDisableRoomsState extends State<AddEditDisableRooms> {
  List<Map<String, String>> rooms = [
    {'name': 'Room 101', 'status': 'Available'},
    {'name': 'Room 102', 'status': 'Disabled'},
    {'name': 'Room 103', 'status': 'Pending'},
  ];

  // Function to open Add Room dialog
  void _addRoom() {
    showDialog(
      context: context,
      builder: (context) {
        String roomName = '';
        return AlertDialog(
          title: const Text('Add New Room'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Room Name'),
            onChanged: (value) {
              roomName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (roomName.isNotEmpty) {
                  setState(() {
                    // Default status = Available
                    rooms.add({'name': roomName, 'status': 'Available'});
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Function to edit room details
  void _editRoom(int index) {
    String roomName = rooms[index]['name']!;
    String roomStatus = rooms[index]['status']!;

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController(
          text: roomName,
        );
        String selectedStatus = roomStatus;

        return AlertDialog(
          title: const Text('Edit Room'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Room Name'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Room Status'),
                items: const [
                  DropdownMenuItem(
                    value: 'Available',
                    child: Text('Available'),
                  ),
                  DropdownMenuItem(value: 'Disabled', child: Text('Disabled')),
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                ],
                onChanged: (value) {
                  selectedStatus = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  rooms[index]['name'] = nameController.text;
                  rooms[index]['status'] = selectedStatus;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Helper: Get color for status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'disabled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Room',
            onPressed: _addRoom,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return ListTile(
            title: Text(room['name']!),
            subtitle: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  const TextSpan(
                    text: 'Status: ',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: room['status'],
                    style: TextStyle(
                      color: _getStatusColor(room['status']!),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editRoom(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      rooms.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
