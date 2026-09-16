# 🏴‍☠️ Jogo Caça ao Tesouro (Portugol Studio)

Simulação automática de um jogo de Caça ao Tesouro em matriz 5x5 desenvolvida em Portugol Studio como trabalho acadêmico.

---

## 📋 Descrição do Projeto
O programa simula a jornada de um jogador em um tabuleiro de 25 casas (matriz 5x5) do ponto `[0,0]` até o objetivo final. O percurso é automatizado e a única entrada exigida do usuário é a definição dos percentuais dos três níveis do jogo.

---

## 🎯 Funcionalidades e Regras Implementadas
- **Configuração Dinâmica dos Níveis:** Entrada dos percentuais dos Níveis I, II e III com validação obrigatória da soma (deve ser exatos 100%).
- **Cálculo de Limites:** Arredondamento automático dos limites de casas por nível usando a biblioteca `Matematica`.
- **Geração do Cenário sem Sobreposição:**
  - `B05` (+5 bateria) em qualquer nível.
  - `B10` (+10 bateria) em qualquer nível.
  - `RIS` (-3 bateria) exclusivo nos Níveis II ou III.
  - `$$$` (Tesouro - Fim de jogo) exclusivo nos Níveis II ou III.
  - 21 casas vazias (`---`).
- **Gestão de Bateria:** Consumo de 10 créditos por rodada. O jogo encerra se a bateria for menor que 10 créditos.

---

## 🛠️ Funções Obrigatórias Utilizadas
- `GerarCenario()`: Inicializa a matriz e faz o sorteio aleatório dos elementos respeitando as restrições de nível e sobreposição.
- `DiminuirBateria()`: Consome 10 créditos de bateria a cada rodada percorrida.
- `Bonus()`: Aplica os bônus de 5 ou 10 créditos à bateria e acumula os créditos obtidos.
- `Risco()`: Aplica a penalidade de 3 créditos de bateria ao cair na casa de risco.

---

## 🚀 Como Executar
1. Baixe ou clone este repositório.
2. Abra o arquivo `Caça_tesouro.por` no [Portugol Studio](https://portugol.dev/).
3. Execute o programa e insira os percentuais para os três níveis quando solicitado.
