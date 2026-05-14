import 'package:flutter/material.dart';
import '../models/exercicio.dart';

class DetalheExercicioScreen extends StatefulWidget {
  final Exercicio exercicio;

  const DetalheExercicioScreen({super.key, required this.exercicio});

  @override
  State<DetalheExercicioScreen> createState() => _DetalheExercicioScreenState();
}

class _DetalheExercicioScreenState extends State<DetalheExercicioScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _frameAtual = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addListener(() {
        final totalFrames = widget.exercicio.frames.length;
        if (totalFrames > 1) {
          setState(() {
            _frameAtual = (_animController.value * totalFrames).floor() % totalFrames;
          });
        }
      });
    _animController.repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _frameLocalPath(int index) {
    final slug = widget.exercicio.slug;
    return 'assets/images/$slug-${index + 1}.png';
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercicio;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(ex.nome,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animação dos frames
            Center(
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    _frameLocalPath(_frameAtual),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.fitness_center, color: Colors.white54, size: 60),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Descrição
            _secao('Sobre o exercício', ex.descricao),
            const SizedBox(height: 16),

            // Músculo alvo
            _chip('Músculo alvo', ex.musculoPrimario == 'BICEPS' ? 'Bíceps' : 'Tríceps',
                Colors.deepPurple),
            const SizedBox(height: 16),

            // Equipamento
            _secaoLista('Equipamento', ex.equipamento),
            const SizedBox(height: 16),

            // Passos de execução
            _secaoLista('Como executar', ex.steps),
            const SizedBox(height: 16),

            // Cuidados
            _secaoListaIcone('⚠️ Cuidados', ex.cuidados, Colors.orange),
            const SizedBox(height: 24),

            // Botão IA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Em breve: sugestões via IA!')),
                  );
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('IA — Sugerir Variação'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secao(String titulo, String conteudo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 6),
        Text(conteudo, style: const TextStyle(color: Colors.white70, height: 1.5)),
      ],
    );
  }

  Widget _chip(String label, String valor, Color cor) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(20)),
          child: Text(valor, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _secaoLista(String titulo, List<String> itens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...itens.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Colors.deepPurple, fontSize: 16)),
                  Expanded(child: Text(item, style: const TextStyle(color: Colors.white70, height: 1.4))),
                ],
              ),
            )),
      ],
    );
  }

  Widget _secaoListaIcone(String titulo, List<String> itens, Color cor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: TextStyle(color: cor, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...itens.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber_rounded, color: cor, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(item, style: const TextStyle(color: Colors.white70, height: 1.4))),
                ],
              ),
            )),
      ],
    );
  }
}