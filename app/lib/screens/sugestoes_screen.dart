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

  static const _bgPrimary   = Color(0xFF1A1A2E);
  static const _bgSecondary = Color(0xFF16213E);
  static const _bgCard      = Color(0xFF1E2A45);
  static const _accent      = Color(0xFF7C3AED);
  static const _accentLight = Color(0xFF9F67FF);

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

  Color _corScore(double score) {
    if (score >= 0.90) return const Color(0xFF4ADE80); // verde
    if (score >= 0.75) return const Color(0xFFFBBF24); // amarelo
    return const Color(0xFF94A3B8); // cinza
  }

  String _labelScore(double score) {
    if (score >= 0.90) return 'Alta compatibilidade';
    if (score >= 0.75) return 'Boa compatibilidade';
    return 'Compatibilidade moderada';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      appBar: AppBar(
        backgroundColor: _bgSecondary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Sugestões de Variação',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: _accent))
          : Column(
              children: [
                _cardOrigem(),
                Expanded(child: _buildLista()),
              ],
            ),
    );
  }

  Widget _cardOrigem() {
    final ex = widget.exercicioOrigem;
    final imagePath = 'assets/images/${ex.slug}-1.png';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accent.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        children: [
          // Imagem do exercício origem
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.fitness_center,
                color: _accent,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Base de comparação',
                  style: TextStyle(
                    color: _accentLight.withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ex.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              ex.musculoPrimario == 'BICEPS' ? 'Bíceps' : 'Tríceps',
              style: const TextStyle(
                color: _accentLight,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLista() {
    if (_sugestoes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: Colors.white24, size: 48),
            SizedBox(height: 12),
            Text('Nenhuma variação encontrada',
                style: TextStyle(color: Colors.white54, fontSize: 16)),
            SizedBox(height: 6),
            Text('Tente outro exercício como base',
                style: TextStyle(color: Colors.white38, fontSize: 13)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _sugestoes.length,
      itemBuilder: (context, index) {
        final entry = _sugestoes[index];
        return _cardSugestao(entry.key, entry.value, index);
      },
    );
  }

  Widget _cardSugestao(Exercicio ex, double score, int index) {
    final imagePath = 'assets/images/${ex.slug}-1.png';
    final cor = _corScore(score);
    final label = _labelScore(score);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetalheExercicioScreen(exercicio: ex)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Imagem
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.fitness_center,
                    color: Colors.white24,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Conteúdo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ex.nome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Label de compatibilidade
                    Text(
                      label,
                      style: TextStyle(
                        color: cor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Barra de progresso
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: score,
                        backgroundColor: Colors.white.withOpacity(0.08),
                        valueColor: AlwaysStoppedAnimation<Color>(cor),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Seta
              Icon(Icons.chevron_right, color: Colors.white24, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}