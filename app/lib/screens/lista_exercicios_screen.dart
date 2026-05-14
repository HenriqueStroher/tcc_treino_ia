import 'package:flutter/material.dart';
import '../models/exercicio.dart';
import '../services/exercicio_service.dart';
import 'detalhe_exercicio_screen.dart';

class ListaExerciciosScreen extends StatefulWidget {
  const ListaExerciciosScreen({super.key});

  @override
  State<ListaExerciciosScreen> createState() => _ListaExerciciosScreenState();
}

class _ListaExerciciosScreenState extends State<ListaExerciciosScreen> {
  final ExercicioService _service = ExercicioService();
  final TextEditingController _buscaController = TextEditingController();

  List<Exercicio> _exercicios = [];
  List<Exercicio> _exerciciosFiltrados = [];
  String _grupoSelecionado = 'BICEPS';
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarExercicios();
  }

  Future<void> _carregarExercicios() async {
    setState(() => _carregando = true);
    final lista = await _service.buscarPorGrupo(_grupoSelecionado);
    setState(() {
      _exercicios = lista;
      _exerciciosFiltrados = lista;
      _carregando = false;
    });
  }

  void _filtrarBusca(String texto) {
    setState(() {
      _exerciciosFiltrados = _exercicios
          .where((ex) => ex.nome.toLowerCase().contains(texto.toLowerCase()))
          .toList();
    });
  }

  void _mudarGrupo(String grupo) {
    setState(() => _grupoSelecionado = grupo);
    _buscaController.clear();
    _carregarExercicios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 28, errorBuilder: (_, __, ___) =>
                const Icon(Icons.fitness_center, color: Colors.white)),
            const SizedBox(width: 8),
            const Text('AppGym', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filtro de grupo muscular
          Container(
            color: const Color(0xFF16213E),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _botaoGrupo('BICEPS', 'Bíceps'),
                const SizedBox(width: 12),
                _botaoGrupo('TRICEPS', 'Tríceps'),
              ],
            ),
          ),
          // Busca
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _buscaController,
              onChanged: _filtrarBusca,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar exercício...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF16213E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Lista
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
                : _exerciciosFiltrados.isEmpty
                    ? const Center(
                        child: Text('Nenhum exercício encontrado',
                            style: TextStyle(color: Colors.white54)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _exerciciosFiltrados.length,
                        itemBuilder: (context, index) {
                          final ex = _exerciciosFiltrados[index];
                          return _cardExercicio(ex);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _botaoGrupo(String grupo, String label) {
    final selecionado = _grupoSelecionado == grupo;
    return GestureDetector(
      onTap: () => _mudarGrupo(grupo),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? Colors.deepPurple : const Color(0xFF0F3460),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: TextStyle(
                color: selecionado ? Colors.white : Colors.white60,
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _cardExercicio(Exercicio ex) {
    // Pega o primeiro frame local
    final frameSlug = ex.slug;
    final imagePath = 'assets/images/$frameSlug-1.png';

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
          subtitle: Text(
            ex.musculoPrimario == 'BICEPS' ? 'Bíceps' : 'Tríceps',
            style: const TextStyle(color: Colors.white54),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        ),
      ),
    );
  }
}