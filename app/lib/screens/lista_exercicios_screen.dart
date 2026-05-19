import 'package:flutter/material.dart';
import '../models/exercicio.dart';
import '../services/exercicio_service.dart';
import 'detalhe_exercicio_screen.dart';

class ListaExerciciosScreen extends StatefulWidget {
  const ListaExerciciosScreen({super.key});

  @override
  State<ListaExerciciosScreen> createState() => _ListaExerciciosScreenState();
}

class _ListaExerciciosScreenState extends State<ListaExerciciosScreen>
    with SingleTickerProviderStateMixin {
  final ExercicioService _service = ExercicioService();
  final TextEditingController _buscaController = TextEditingController();
  late AnimationController _animController;

  List<Exercicio> _exercicios = [];
  List<Exercicio> _exerciciosFiltrados = [];
  String _grupoSelecionado = 'BICEPS';
  bool _carregando = true;

  // Cores do app
  static const _bgPrimary   = Color(0xFF1A1A2E);
  static const _bgSecondary = Color(0xFF16213E);
  static const _bgCard      = Color(0xFF1E2A45);
  static const _accent      = Color(0xFF7C3AED);
  static const _accentLight = Color(0xFF9F67FF);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _carregarExercicios();
  }

  @override
  void dispose() {
    _animController.dispose();
    _buscaController.dispose();
    super.dispose();
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
    if (_grupoSelecionado == grupo) return;
    setState(() => _grupoSelecionado = grupo);
    _buscaController.clear();
    _carregarExercicios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFiltroGrupo(),
          _buildBusca(),
          Expanded(child: _buildLista()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _bgSecondary,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_accent, _accentLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/images/logo.png',
              height: 20,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'AppGym',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroGrupo() {
    return Container(
      color: _bgSecondary,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          _botaoGrupo('BICEPS', 'Bíceps'),
          const SizedBox(width: 10),
          _botaoGrupo('TRICEPS', 'Tríceps'),
        ],
      ),
    );
  }

  Widget _botaoGrupo(String grupo, String label) {
    final selecionado = _grupoSelecionado == grupo;
    return Expanded(
      child: GestureDetector(
        onTap: () => _mudarGrupo(grupo),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: selecionado
                ? const LinearGradient(
                    colors: [_accent, _accentLight],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            color: selecionado ? null : const Color(0xFF0F3460),
            borderRadius: BorderRadius.circular(12),
            boxShadow: selecionado
                ? [
                    BoxShadow(
                      color: _accent.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selecionado ? Colors.white : Colors.white54,
              fontWeight: selecionado ? FontWeight.w700 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusca() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: _buscaController,
        onChanged: _filtrarBusca,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Buscar exercício...',
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 15),
          prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
          filled: true,
          fillColor: _bgCard,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _accent, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildLista() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(color: _accent),
      );
    }

    if (_exerciciosFiltrados.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, color: Colors.white24, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Nenhum exercício encontrado',
              style: TextStyle(color: Colors.white38, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: _exerciciosFiltrados.length,
      itemBuilder: (context, index) {
        return _cardExercicio(_exerciciosFiltrados[index], index);
      },
    );
  }

  Widget _cardExercicio(Exercicio ex, int index) {
    final imagePath = 'assets/images/${ex.slug}-1.png';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetalheExercicioScreen(exercicio: ex)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: _bgCard,
          borderRadius: BorderRadius.circular(16),
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
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  imagePath,
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.fitness_center,
                    color: Colors.white24,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Texto
              Expanded(
                child: Text(
                  ex.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
              ),
              // Seta
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
