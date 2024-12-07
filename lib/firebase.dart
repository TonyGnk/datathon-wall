import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirestoreService {
  // Fetch all teams data
  static Future<List<Map<String, dynamic>>> getTeamsData() async {
    final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/entry-scanner-2934c/databases/(default)/documents/participants');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('documents')) {
          // Extract relevant team data
          return (data['documents'] as List).map<Map<String, dynamic>>((doc) {
            final fields = doc['fields'] ?? {};
            final members = fields['members']['arrayValue']['values'] ?? [];
            return {
              'teamName': fields['teamName']['stringValue'] ?? 'Unknown Team',
              'members': members.map<Map<String, dynamic>>((member) {
                final memberFields = member['mapValue']['fields'] ?? {};
                return {
                  'email': memberFields['email']['stringValue'] ?? '',
                  'name': memberFields['name']['stringValue'] ?? '',
                  'hasArrived':
                      memberFields['hasArrived']['booleanValue'] ?? false,
                };
              }).toList(),
            };
          }).toList();
        }
      }
      print('Error: ${response.statusCode} - ${response.body}');
      return [];
    } catch (e) {
      print('Error fetching teams: $e');
      return [];
    }
  }
}

class TeamsList extends StatefulWidget {
  const TeamsList({super.key});

  @override
  _TeamsListState createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> teamsWithArrivals = [];
  final Set<String> currentTeamNames = {}; // Track existing team names
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _fetchTeamsData();
    // Uncomment for periodic polling
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchTeamsData();
    });
  }

  void _fetchTeamsData() async {
    final newTeams = await FirestoreService.getTeamsData();

    final filteredTeams = newTeams
        .where((team) =>
            team['members'].any((member) => member['hasArrived'] == true))
        .map((team) {
      final arrivedCount = team['members']
          .where((member) => member['hasArrived'] == true)
          .length;
      final totalMembers = team['members'].length;

      return {
        'teamName': team['teamName'],
        'arrivedCount': arrivedCount,
        'totalMembers': totalMembers,
      };
    }).toList();

    setState(() {
      for (var team in filteredTeams) {
        // Find matching team by name
        final existingTeamIndex = teamsWithArrivals.indexWhere(
            (existingTeam) => existingTeam['teamName'] == team['teamName']);

        if (existingTeamIndex == -1) {
          // New team: Add it
          teamsWithArrivals.add(team);
          currentTeamNames.add(team['teamName']);
          _triggerAnimation(team); // Trigger animation for new team
        } else {
          // Existing team: Check for arrivedCount change
          final existingTeam = teamsWithArrivals[existingTeamIndex];
          if (existingTeam['arrivedCount'] != team['arrivedCount']) {
            teamsWithArrivals[existingTeamIndex] = team; // Update team
            _triggerAnimation(team); // Trigger animation for count change
          }
        }
      }

      // Remove teams no longer in the list
      final newTeamNames = filteredTeams.map((e) => e['teamName']).toSet();
      teamsWithArrivals
          .removeWhere((team) => !newTeamNames.contains(team['teamName']));
      currentTeamNames.retainWhere(newTeamNames.contains);
    });
  }

  void _triggerAnimation(Map<String, dynamic> team) {
    // Logic to trigger animation for a specific item can go here.
    // Currently, it can be used to animate adding cards individually.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _fetchTeamsData,
      //   child: const Icon(Icons.refresh),
      // ),
      body: teamsWithArrivals.isEmpty
          ? const Center()
          : Padding(
              padding: const EdgeInsets.all(14.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 4 / 1,
                ),
                itemCount: teamsWithArrivals.length,
                itemBuilder: (context, index) {
                  final team = teamsWithArrivals[index];
                  return _buildAnimatedGridItem(team);
                },
              ),
            ),
    );
  }

  Widget _buildAnimatedGridItem(Map<String, dynamic> team) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0), // Adjust for scaling effect
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: _buildGridItem(team),
        );
      },
    );
  }

  Widget _buildGridItem(Map<String, dynamic> team) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              team['teamName'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            if (team['arrivedCount'] == team['totalMembers'])
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: 1.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(left: 8),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              )
            else
              Text(
                '${team['arrivedCount']}/${team['totalMembers']}',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
