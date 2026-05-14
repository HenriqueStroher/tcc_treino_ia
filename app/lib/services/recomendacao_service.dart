import '../models/exercicio.dart';

class RecomendacaoService {
  // ─────────────────────────────────────────
  // PESOS DO ALGORITMO (Content-Based Filtering)
  // ─────────────────────────────────────────
  static const double _pesoMusculoPrimario = 0.40;
  static const double _pesoVetorForca      = 0.25;
  static const double _pesoPlanoMovimento  = 0.20;
  static const double _pesoEquipamento     = 0.15;

  // Limiar mínimo de similaridade
  static const double _limiar = 0.60;

  // ─────────────────────────────────────────
  // MÉTODO PRINCIPAL
  // ─────────────────────────────────────────
  List<MapEntry<Exercicio, double>> sugerirVariacoes(
    Exercicio origem,
    List<Exercicio> catalogo,
  ) {
    final candidatos = catalogo
        .where((ex) => ex.slug != origem.slug)
        .where((ex) => ex.musculoPrimario == origem.musculoPrimario)
        .toList();

    final scores = <MapEntry<Exercicio, double>>[];

    for (final candidato in candidatos) {
      final score = _calcularSimilaridade(origem, candidato);
      if (score >= _limiar) {
        scores.add(MapEntry(candidato, score));
      }
    }

    // Rankeia do maior para o menor score
    scores.sort((a, b) => b.value.compareTo(a.value));

    return scores;
  }

  // ─────────────────────────────────────────
  // CÁLCULO DE SIMILARIDADE
  // ─────────────────────────────────────────
  double _calcularSimilaridade(Exercicio origem, Exercicio candidato) {
    double score = 0.0;

    // 1. Músculo primário (sempre igual pois filtramos antes — peso total)
    score += _pesoMusculoPrimario;

    // 2. Vetor de força
    if (origem.vetorForca == candidato.vetorForca) {
      score += _pesoVetorForca;
    }

    // 3. Plano de movimento
    if (origem.planoMovimento == candidato.planoMovimento) {
      score += _pesoPlanoMovimento;
    }

    // 4. Equipamento — penaliza se for o mesmo (queremos variações)
    final mesmoEquipamento = origem.equipamento
        .any((eq) => candidato.equipamento.contains(eq));
    if (!mesmoEquipamento) {
      score += _pesoEquipamento;
    }

    return score;
  }
}