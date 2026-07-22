import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestEstateConnection extends StatefulWidget {
  const TestEstateConnection({super.key});

  @override
  State<TestEstateConnection> createState() => _TestEstateConnectionState();
}

class _TestEstateConnectionState extends State<TestEstateConnection> {
  String _result = 'Testing...';

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    try {
      setState(() => _result = 'Connecting to Supabase...');
      
      final supabase = Supabase.instance.client;
      
      // Test 1: Check auth
      final user = supabase.auth.currentUser;
      setState(() => _result = 'User: ${user?.id ?? "NO USER"}\n');
      
      // Test 2: Try to fetch buildings
      setState(() => _result += 'Fetching buildings...\n');
      final buildings = await supabase
          .from('fixflow_buildings')
          .select()
          .order('display_order', ascending: true);
      
      setState(() => _result += 'Buildings: ${buildings.length} found\n');
      
      // Test 3: Try to fetch stairwells
      setState(() => _result += 'Fetching stairwells...\n');
      final stairwells = await supabase
          .from('fixflow_stairwells')
          .select()
          .order('display_order', ascending: true);
      
      setState(() => _result += 'Stairwells: ${stairwells.length} found\n');
      
      setState(() => _result += '\n✅ SUCCESS! Connection works!');
      
    } catch (e) {
      setState(() => _result = '❌ ERROR: $e\n\nType: ${e.runtimeType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Estate Connection')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(_result),
              ),
            ),
            ElevatedButton(
              onPressed: _testConnection,
              child: const Text('Test Again'),
            ),
          ],
        ),
      ),
    );
  }
}