import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppGym',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TesteFirebase(),
    );
  }
}

class TesteFirebase extends StatefulWidget {
  const TesteFirebase({super.key});

  @override
  State<TesteFirebase> createState() => _TesteFirebaseState();
}

class _TesteFirebaseState extends State<TesteFirebase> {
  List<String> exercicios = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarExercicios();
  }

  Future<void> carregarExercicios() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('exercicios')
        .limit(5)
        .get();

    setState(() {
      exercicios = snapshot.docs.map((doc) => doc['nome'] as String).toList();
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppGym — Teste Firebase')),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: exercicios.length,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text(exercicios[index]),
              ),
            ),
    );
  }
}