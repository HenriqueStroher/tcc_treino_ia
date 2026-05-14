import 'package:flutter/material.dart';
import '../models/exercicio.dart';
import '../services/recomendacao_service.dart';
import '../services/exercicio_service.dart';
import 'detalhe_exercicio_screen.dart';

class SugestoesScreen extends StatefulWidget {
  final Exercicio exercicioOrigem;

  const SugestoesScreen({super.key, required this.exercicioOrigem});

  @override
  State<SugestoesScreen> createState() => _SugestoesScreenState();
}

class _SugestoesScreenState extends State<SugestoesScreen> {
  final RecomendacaoService _recomendacao = RecomendacaoService();
  final ExercicioService _exercicioService = ExercicioService();

  List<MapEntry<Exercicio, double>> _sugestoes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _gerarSugestoes();
  }

  Future<void> _gerarSugestoes() async {
    final catalogo = await _exercicioService
        .buscarPorGrupo(widget.exercicioOrigem.musculoPrimario);

    final sugestoes = _recomendacao.sugerirVariacoes(
      widget.exercicioOrigem,
      catalogo,
    );

    setState(() {
      _sugestoes = sugestoes;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Variações Sugeridas pela IA',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : Column(
              children: [
                // Card do exercício origem
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.fitness_center, color: Colors.deepPurple),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Exercício original',
                                style: TextStyle(color: Colors.white54, fontSize: 12)),
                            Text(widget.exercicioOrigem.nome,
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Resultado
                Expanded(
                  child: _sugestoes.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, color: Colors.white54, size: 48),
                              SizedBox(height: 12),
                              Text('Nenhuma variação encontrada',
                                  style: TextStyle(color: Colors.white54, fontSize: 16)),
                              SizedBox(height: 6),
                              Text('Tente outro exercício como base',
                                  style: TextStyle(color: Colors.white38, fontSize: 13)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _sugestoes.length,
                          itemBuilder: (context, index) {
                            final entry = _sugestoes[index];
                            final ex = entry.key;
                            final score = entry.value;
                            return _cardSugestao(ex, score, index);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _cardSugestao(Exercicio ex, double score, int index) {
    final imagePath = 'assets/images/${ex.slug}-1.png';
    final porcentagem = (score * 100).toStringAsFixed(0);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetalheExercicioScreen(exercicio: ex)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: score >= 0.90
                ? Colors.green
                : score >= 0.75
                    ? Colors.orange
                    : Colors.white12,
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                height: 60,
                color: const Color(0xFF0F3460),
                child: const Icon(Icons.fitness_center, color: Colors.white54),
              ),
            ),
          ),
          title: Text(ex.nome,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: score >= 0.90
                        ? Colors.green.withOpacity(0.2)
                        : score >= 0.75
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.white12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$porcentagem% compatível',
                    style: TextStyle(
                      color: score >= 0.90
                          ? Colors.green
                          : score >= 0.75
                              ? Colors.orange
                              : Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        ),
      ),
    );
  }
}