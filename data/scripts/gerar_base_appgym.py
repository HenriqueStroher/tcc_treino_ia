import json

# ─────────────────────────────────────────────
# Exercícios selecionados para o beta v1
# 10 bíceps + 10 tríceps = 20 exercícios
# ─────────────────────────────────────────────
EXERCICIOS_SELECIONADOS = {

    # ══ BÍCEPS ══════════════════════════════

    "biceps-curl-with-dumbbell": {
        "nomePT": "Rosca com Haltere",
        "descricaoPT": "Exercício básico e eficaz para isolamento do bíceps com halteres.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.88,
        "escoreRiscoLesao": 0.10,
        "cuidados": [
            "Mantenha os cotovelos fixos ao lado do corpo",
            "Não balance o tronco durante o movimento",
            "Controle a descida do peso de forma lenta"
        ]
    },
    "biceps-curls-with-barbell": {
        "nomePT": "Rosca Direta com Barra",
        "descricaoPT": "Exercício básico para o bíceps utilizando barra reta.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.90,
        "escoreRiscoLesao": 0.20,
        "cuidados": [
            "Não balance o tronco durante o movimento",
            "Mantenha os cotovelos fixos ao lado do corpo",
            "Evite hiperextender os pulsos"
        ]
    },
    "ez-bar-curl-with-barbell": {
        "nomePT": "Rosca com Barra W",
        "descricaoPT": "Rosca com barra W, que reduz o estresse nos pulsos em relação à barra reta.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.89,
        "escoreRiscoLesao": 0.15,
        "cuidados": [
            "Mantenha os cotovelos fixos ao lado do corpo",
            "Não balance o tronco",
            "A barra W reduz estresse no pulso — mantenha a pegada natural"
        ]
    },
    "concentration-curls-with-dumbbell": {
        "nomePT": "Rosca Concentrada com Haltere",
        "descricaoPT": "Exercício de isolamento máximo do bíceps realizado sentado com apoio do cotovelo na coxa.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.95,
        "escoreRiscoLesao": 0.10,
        "cuidados": [
            "Apoie o cotovelo firmemente na parte interna da coxa",
            "Realize o movimento de forma lenta e controlada",
            "Não torça o pulso durante o movimento"
        ]
    },
    "hammer-curls-with-rope-and-cable": {
        "nomePT": "Rosca Martelo no Cabo com Corda",
        "descricaoPT": "Variação da rosca martelo no cabo com corda, trabalhando bíceps e braquiorradial.",
        "vetorForca": "angular",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.83,
        "escoreRiscoLesao": 0.10,
        "cuidados": [
            "Mantenha o polegar apontado para cima durante o movimento",
            "Não balance o tronco",
            "Controle a tensão do cabo no retorno"
        ]
    },
    "preacher-curl-with-barbell": {
        "nomePT": "Rosca Scott com Barra",
        "descricaoPT": "Rosca Scott com barra que isola o bíceps eliminando o uso do tronco.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.92,
        "escoreRiscoLesao": 0.25,
        "cuidados": [
            "Não estenda totalmente o cotovelo para evitar lesão",
            "Mantenha o braço apoiado no suporte o tempo todo",
            "Use cargas moderadas — o isolamento aumenta o risco"
        ]
    },
    "incline-inner-biceps-curl-with-dumbbell-2": {
        "nomePT": "Rosca Inclinada com Haltere",
        "descricaoPT": "Rosca realizada no banco inclinado que aumenta o alongamento do bíceps.",
        "vetorForca": "angular",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.91,
        "escoreRiscoLesao": 0.20,
        "cuidados": [
            "Mantenha as costas totalmente apoiadas no banco inclinado",
            "Não force a amplitude além do confortável",
            "Realize o movimento de forma lenta e controlada"
        ]
    },
    "standing-biceps-curl-with-cable": {
        "nomePT": "Rosca no Cabo em Pé",
        "descricaoPT": "Rosca no cabo em pé que mantém tensão constante no bíceps durante todo o movimento.",
        "vetorForca": "angular",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.87,
        "escoreRiscoLesao": 0.15,
        "cuidados": [
            "Mantenha os cotovelos fixos ao lado do corpo",
            "Não use impulso do tronco",
            "Aproveite a tensão constante do cabo — faça o movimento devagar"
        ]
    },
    "seated-biceps-curl-with-dumbbell": {
        "nomePT": "Rosca com Haltere Sentado",
        "descricaoPT": "Versão sentada da rosca com haltere, que reduz o uso do tronco como compensação.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.87,
        "escoreRiscoLesao": 0.10,
        "cuidados": [
            "Mantenha as costas apoiadas no banco",
            "Não balance o tronco para frente",
            "Mantenha os cotovelos fixos durante o movimento"
        ]
    },
    "alternating-biceps-curl-with-dumbbell": {
        "nomePT": "Rosca Alternada com Haltere",
        "descricaoPT": "Rosca com halteres alternando os braços, permitindo maior foco em cada lado.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.86,
        "escoreRiscoLesao": 0.10,
        "cuidados": [
            "Não balance o tronco ao alternar os braços",
            "Mantenha o cotovelo do braço que descansa fixo",
            "Controle a descida do peso"
        ]
    },

    # ══ TRÍCEPS ═════════════════════════════

    "triceps-pushdown-with-cable": {
        "nomePT": "Pushdown de Tríceps no Cabo",
        "descricaoPT": "Exercício fundamental de isolamento do tríceps utilizando cabo com barra reta.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.88,
        "escoreRiscoLesao": 0.15,
        "cuidados": [
            "Mantenha os cotovelos fixos e colados ao lado do corpo",
            "Não incline o tronco para frente para usar mais carga",
            "Controle o retorno do cabo — não deixe subir de forma descontrolada"
        ]
    },
    "tate-press-with-dumbbell": {
        "nomePT": "Tate Press com Haltere",
        "descricaoPT": "Exercício avançado de tríceps realizado deitado que trabalha o músculo de forma diferente.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.85,
        "escoreRiscoLesao": 0.30,
        "cuidados": [
            "Exercício avançado — não recomendado para iniciantes",
            "Mantenha os cotovelos apontados para cima durante todo o movimento",
            "Use cargas leves inicialmente para aprender a técnica"
        ]
    },
    "tricep-dips-using-body-weight": {
        "nomePT": "Mergulho de Tríceps no Peso Corporal",
        "descricaoPT": "Exercício com peso corporal que trabalha fortemente o tríceps usando barras paralelas ou banco.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.86,
        "escoreRiscoLesao": 0.25,
        "cuidados": [
            "Não desça além de 90 graus no cotovelo",
            "Mantenha o tronco levemente inclinado à frente",
            "Evite este exercício se tiver problemas no ombro"
        ]
    },
    "seated-two-arm-triceps-extension-with-dumbbell": {
        "nomePT": "Extensão de Tríceps Acima da Cabeça Sentado",
        "descricaoPT": "Extensão de tríceps com haltere acima da cabeça sentado, focando na cabeça longa do tríceps.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.89,
        "escoreRiscoLesao": 0.25,
        "cuidados": [
            "Mantenha os cotovelos apontados para cima e próximos à cabeça",
            "Não arqueie excessivamente a lombar",
            "Controle o peso na descida atrás da cabeça"
        ]
    },
    "triceps-kickback-with-dumbbell": {
        "nomePT": "Tríceps Coice com Haltere",
        "descricaoPT": "Exercício de isolamento do tríceps realizado curvado para frente com haltere.",
        "vetorForca": "horizontal",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.84,
        "escoreRiscoLesao": 0.15,
        "cuidados": [
            "Mantenha o cotovelo fixo e paralelo ao tronco",
            "Não balance o tronco para dar impulso",
            "Estenda completamente o braço no topo do movimento"
        ]
    },
    "triceps-pushdown-with-rope-and-cable": {
        "nomePT": "Pushdown de Tríceps com Corda no Cabo",
        "descricaoPT": "Variação do pushdown com corda que permite abertura no final do movimento, aumentando a contração.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.90,
        "escoreRiscoLesao": 0.15,
        "cuidados": [
            "Abra a corda para os lados no final do movimento para máxima contração",
            "Mantenha os cotovelos fixos ao lado do corpo",
            "Não use o tronco para aumentar a carga"
        ]
    },
    "reverse-grip-triceps-pushdown": {
        "nomePT": "Pushdown de Tríceps com Pegada Inversa",
        "descricaoPT": "Variação do pushdown com pegada supinada que ativa mais a cabeça medial do tríceps.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.86,
        "escoreRiscoLesao": 0.15,
        "cuidados": [
            "Mantenha os pulsos retos durante o movimento",
            "Cotovelos fixos ao lado do corpo",
            "Use carga menor que no pushdown tradicional"
        ]
    },
    "standing-triceps-extension": {
        "nomePT": "Extensão de Tríceps em Pé",
        "descricaoPT": "Extensão de tríceps realizada em pé com barra ou haltere acima da cabeça.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.87,
        "escoreRiscoLesao": 0.20,
        "cuidados": [
            "Mantenha os cotovelos apontados para cima próximos à cabeça",
            "Não arqueie a lombar — contraia o core",
            "Controle a descida do peso atrás da cabeça"
        ]
    },
    "decline-close-grip-bench-to-skull-crusher": {
        "nomePT": "Supino Fechado Declinado com Skull Crusher",
        "descricaoPT": "Exercício combinado que une o supino fechado com a extensão de crânio no banco declinado.",
        "vetorForca": "angular",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.91,
        "escoreRiscoLesao": 0.40,
        "cuidados": [
            "Exercício avançado — requer supervisão",
            "Mantenha controle total da barra em todo momento",
            "Não realize sem um parceiro de treino para segurança"
        ]
    },
    "tricep-dips": {
        "nomePT": "Mergulho de Tríceps na Máquina",
        "descricaoPT": "Versão do mergulho de tríceps na máquina, mais segura e controlada que a versão livre.",
        "vetorForca": "vertical",
        "planoMovimento": "sagital",
        "ativacaoMuscular": 0.84,
        "escoreRiscoLesao": 0.15,
        "cuidados": [
            "Ajuste o banco para a altura adequada antes de começar",
            "Mantenha as costas apoiadas no suporte",
            "Não deixe os ombros subirem durante o movimento"
        ]
    },
}

# ─────────────────────────────────────────────
# Traduções
# ─────────────────────────────────────────────
EQUIPAMENTO_PT = {
    "barbell": "barra", "dumbbell": "haltere", "cable": "cabo",
    "machine": "maquina", "bodyweight": "peso_corporal", "ez-bar": "barra_w",
    "bench": "banco", "pull-up bar": "barra_fixa", "rope": "corda", "band": "elastico",
}

MUSCULO_PT = {
    "shoulders": "ombros", "forearm": "antebraco", "chest": "peito",
    "back": "costas", "core": "core", "triceps": "triceps", "biceps": "biceps",
    "brachialis": "braquial", "brachioradialis": "braquiorradial",
}

def traduzir_lista(lista, dicionario):
    return [dicionario.get(item, item) for item in lista]

def processar_exercicio(ex, extras):
    return {
        "id": str(ex["id"]),
        "slug": ex.get("name", ""),
        "nome": extras.get("nomePT") or ex.get("title", ""),
        "descricao": extras.get("descricaoPT") or ex.get("primer", ""),
        "musculoPrimario": ex.get("primary", "").upper(),
        "musculoSecundario": traduzir_lista(ex.get("secondary", []), MUSCULO_PT),
        "tipo": ex.get("type", ""),
        "equipamento": traduzir_lista(ex.get("equipment", []), EQUIPAMENTO_PT),
        "frames": ex.get("img", []),
        "steps": ex.get("steps", []),
        "cuidados": extras.get("cuidados", []),
        "vetorForca": extras["vetorForca"],
        "planoMovimento": extras["planoMovimento"],
        "ativacaoMuscular": extras["ativacaoMuscular"],
        "escoreRiscoLesao": extras["escoreRiscoLesao"],
        "validadoProfissional": False,
        "fonte": "everkinetic",
        "versao": "1.0.0"
    }

def main():
    with open("exercises.json", "r", encoding="utf-8") as f:
        todos = json.load(f)

    por_slug = {ex["name"]: ex for ex in todos}
    processados = []
    nao_encontrados = []

    for slug, extras in EXERCICIOS_SELECIONADOS.items():
        if slug in por_slug:
            processados.append(processar_exercicio(por_slug[slug], extras))
        else:
            nao_encontrados.append(slug)

    biceps  = [e for e in processados if e["musculoPrimario"] == "BICEPS"]
    triceps = [e for e in processados if e["musculoPrimario"] == "TRICEPS"]

    saida = {
        "versao": "1.0.0",
        "escopo": "beta_v1",
        "grupos": ["BICEPS", "TRICEPS"],
        "total": len(processados),
        "totalBiceps": len(biceps),
        "totalTriceps": len(triceps),
        "exercicios": processados
    }

    with open("appgym_exercises.json", "w", encoding="utf-8") as f:
        json.dump(saida, f, ensure_ascii=False, indent=2)

    print(f"✅ Base gerada: appgym_exercises.json")
    print(f"   → Bíceps:  {len(biceps)} exercícios")
    print(f"   → Tríceps: {len(triceps)} exercícios")
    print(f"   → Total:   {len(processados)} exercícios")

    if nao_encontrados:
        print(f"\n⚠️  {len(nao_encontrados)} slug(s) não encontrado(s):")
        for s in nao_encontrados:
            print(f"   - {s}")
    else:
        print("\n✅ Todos os exercícios foram encontrados e processados!")

if __name__ == "__main__":
    main()
