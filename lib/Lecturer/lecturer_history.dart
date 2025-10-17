import 'package:flutter/material.dart';

class LecturerHistory extends StatefulWidget {
  LecturerHistory({super.key});

  // Booking history with student name added
  final List bookingHistory = [
    {
      'name': 'lecturer1',
      'student': 'Alice',
      'date': '2025-10-01',
      'room': 'room1',
      'status': 'Approved',
    },
    {
      'name': 'lecturer2',
      'student': 'Bob',
      'date': '2025-10-05',
      'room': 'room2',
      'status': 'Rejected',
    },
    {
      'name': 'lecturer3',
      'student': 'Charlie',
      'date': '2025-10-10',
      'room': 'room3',
      'status': 'Pending',
    },
    {
      'name': 'lecturer1',
      'student': 'David',
      'date': '2025-10-02',
      'room': 'room4',
      'status': 'Approved',
    },
    {
      'name': 'lecturer2',
      'student': 'Emma',
      'date': '2025-10-07',
      'room': 'room5',
      'status': 'Rejected',
    },
    {
      'name': 'lecturer3',
      'student': 'Frank',
      'date': '2025-10-11',
      'room': 'room6',
      'status': 'Pending',
    },
  ];

  @override
  State<LecturerHistory> createState() => _LecturerHistoryState();
}

class _LecturerHistoryState extends State<LecturerHistory> {
  String searchQuery = '';
  DateTime? selectedDate;

  // reset the date filter
  void _clearFilter() {
    setState(() {
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Search by student name + optional date
    final filteredList = widget.bookingHistory.where((history) {
      final searchLower = searchQuery.toLowerCase();
      final matchesSearch = history['student']
          .toString()
          .toLowerCase()
          .contains(searchLower);

      final matchesDate =
          selectedDate == null ||
          history['date'] == selectedDate?.toIso8601String().split('T')[0];

      return matchesSearch && matchesDate;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Lecturer Approval History')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search + Filter
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search by student name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_alt, color: Colors.blue),
                  tooltip: 'Filter by Date',
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
                if (selectedDate != null)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    tooltip: 'Clear Date Filter',
                    onPressed: _clearFilter,
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // History List
            Expanded(
              child: filteredList.isEmpty
                  ? const Center(
                      child: Text(
                        'No matching booking history found.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final history = filteredList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(history['name']),
                            subtitle: Text(
                              'Student: ${history['student']}\n${history['date']} • ${history['room']}',
                            ),
                            isThreeLine: true,
                            trailing: Text(
                              history['status'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: history['status'] == 'Approved'
                                    ? Colors.green
                                    : history['status'] == 'Rejected'
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
