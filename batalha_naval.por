programa
{
  inclua biblioteca Tipos --> t
  inclua biblioteca Util --> u
  inclua biblioteca Matematica --> m

  // Estado Global do Jogo
  cadeia tabuleiro[5][5]
  cadeia tabuleiroVisivel[5][5]
  inteiro bateria = 100
  inteiro bonusObtidos = 0
  inteiro limiteNivel1 = 0
  inteiro limiteNivel2 = 0
  inteiro casaRisco = 0
  inteiro casaTesouro = 0
  inteiro casaB05 = 0
  inteiro casaB10 = 0

  funcao inicio()
  {
    inteiro totalRodadas = 0
    logico tesouroEncontrado = falso
    cadeia nivelAtingido = "I"

    real perc1 = 0.0, perc2 = 0.0, perc3 = 0.0
    real somaPerc = 0.0
    cadeia txt1, txt2, txt3
    cadeia txtLinha

    // 1. Configuração dos Níveis com Tratamento de Texto
    faca 
    {
      escreva("========== CONFIGURAÇÃO DOS NÍVEIS ==========\n")
      
      // Validação do Nível I
      faca
      {
        escreva("Informe o percentual do Nível I (%): ")
        leia(txt1)
        se (t.cadeia_e_real(txt1))
        {
          perc1 = t.cadeia_para_real(txt1)
        }
        senao se (t.cadeia_e_inteiro(txt1, 10))
        {
          perc1 = t.cadeia_para_inteiro(txt1, 10) * 1.0
        }
        senao
        {
          escreva("[ERRO] '", txt1, "' não é um número! Digite um valor numérico válido.\n")
          perc1 = -1.0
        }
      } enquanto (perc1 <= 0.0)

      // Validação do Nível II
      faca
      {
        escreva("Informe o percentual do Nível II (%): ")
        leia(txt2)
        se (t.cadeia_e_real(txt2))
        {
          perc2 = t.cadeia_para_real(txt2)
        }
        senao se (t.cadeia_e_inteiro(txt2, 10))
        {
          perc2 = t.cadeia_para_inteiro(txt2, 10) * 1.0
        }
        senao
        {
          escreva("[ERRO] '", txt2, "' não é um número! Digite um valor numérico válido.\n")
          perc2 = -1.0
        }
      } enquanto (perc2 <= 0.0)

      // Validação do Nível III
      faca
      {
        escreva("Informe o percentual do Nível III (%): ")
        leia(txt3)
        se (t.cadeia_e_real(txt3))
        {
          perc3 = t.cadeia_para_real(txt3)
        }
        senao se (t.cadeia_e_inteiro(txt3, 10))
        {
          perc3 = t.cadeia_para_inteiro(txt3, 10) * 1.0
        }
        senao
        {
          escreva("[ERRO] '", txt3, "' não é um número! Digite um valor numérico válido.\n")
          perc3 = -1.0
        }
      } enquanto (perc3 <= 0.0)

      somaPerc = perc1 + perc2 + perc3

      se (somaPerc != 100.0) 
      {
        escreva("\n[ERRO] A soma dos percentuais deve ser exatamente 100%! (Soma atual: ", somaPerc, "%). Tente novamente.\n\n")
      }
    } enquanto (somaPerc != 100.0)

    // 2. Cálculo dos Limites com Travas de Segurança
    limiteNivel1 = t.real_para_inteiro(m.arredondar(25.0 * (perc1 / 100.0), 0))
    limiteNivel2 = t.real_para_inteiro(m.arredondar(25.0 * ((perc1 + perc2) / 100.0), 0))

    se (limiteNivel1 < 1) limiteNivel1 = 1
    se (limiteNivel1 >= 24) limiteNivel1 = 23
    se (limiteNivel2 <= limiteNivel1) limiteNivel2 = limiteNivel1 + 1
    se (limiteNivel2 >= 25) limiteNivel2 = 24

    // 3. Geração do Cenário
    GerarCenario()

    // 4. Fluxo de Jogabilidade Interativa
    enquanto (bateria >= 10 e nao tesouroEncontrado)
    {
      exibirTabuleiroVisivel()
      escreva("\n------------------------------------------------\n")
      escreva("Bateria Atual: ", bateria, " créditos | Bônus Acumulados: ", bonusObtidos, " créditos\n")

      caracter colChar
      inteiro linhaNum
      inteiro linIdx = -1
      inteiro colIdx = -1
      logico jogadaValida = falso

      faca
      {
        // Validação da COLUNA
        faca
        {
          escreva("\nInforme a COLUNA (A, B, C, D ou E): ")
          leia(colChar)

          se (colChar == 'A' ou colChar == 'a') colIdx = 0
          senao se (colChar == 'B' ou colChar == 'b') colIdx = 1
          senao se (colChar == 'C' ou colChar == 'c') colIdx = 2
          senao se (colChar == 'D' ou colChar == 'd') colIdx = 3
          senao se (colChar == 'E' ou colChar == 'e') colIdx = 4
          senao colIdx = -1

          se (colIdx == -1)
          {
            escreva("[ERRO] Coluna '", colChar, "' inválida! Digite apenas uma das letras: A, B, C, D ou E.\n")
          }
        } enquanto (colIdx == -1)

        // Validação da LINHA com Tratamento de Texto
        faca
        {
          escreva("Informe a LINHA (1 a 5): ")
          leia(txtLinha)

          se (t.cadeia_e_inteiro(txtLinha, 10))
          {
            linhaNum = t.cadeia_para_inteiro(txtLinha, 10)
            linIdx = linhaNum - 1

            se (linIdx < 0 ou linIdx > 4)
            {
              escreva("[ERRO] Linha '", txtLinha, "' inválida! Digite apenas um número entre 1 e 5.\n")
            }
          }
          senao
          {
            linIdx = -1
            escreva("[ERRO] '", txtLinha, "' não é um número inteiro! Digite um valor entre 1 e 5.\n")
          }
        } enquanto (linIdx < 0 ou linIdx > 4)

        // Validação de Casa Já Revelada
        se (tabuleiroVisivel[linIdx][colIdx] != "[ ~ ]")
        {
          escreva("\n[AVISO] A casa ", colChar, txtLinha, " já foi revelada! Escolha uma posição ainda não visitada.\n")
          jogadaValida = falso
        }
        senao
        {
          jogadaValida = verdadeiro
        }

      } enquanto (nao jogadaValida)

      // Consumo de Bateria por jogada
      DiminuirBateria()
      totalRodadas++

      cadeia item = tabuleiro[linIdx][colIdx]
      tabuleiroVisivel[linIdx][colIdx] = "[" + item + "]"

      // Atualiza o nível máximo atingido
      inteiro numeroCasa = (linIdx * 5) + colIdx + 1
      se (numeroCasa <= limiteNivel1) 
      {
        nivelAtingido = "I"
      }
      senao se (numeroCasa <= limiteNivel2) 
      {
        nivelAtingido = "II"
      }
      senao 
      {
        nivelAtingido = "III"
      }

      // Reação ao Item Descoberto
      escreva("\n>>> Jogada em ", colChar, txtLinha, " (-10 Bateria) <<<\n")
      se (item == "B05") 
      {
        Bonus(5)
        escreva("🎉 BÔNUS ENCONTRADO! Você ganhou +5 créditos de bateria!\n")
      }
      senao se (item == "B10") 
      {
        Bonus(10)
        escreva("⭐ SUPER BÔNUS ENCONTRADO! Você ganhou +10 créditos de bateria!\n")
      }
      senao se (item == "RIS") 
      {
        Risco()
        escreva("⚠️ CASA DE RISCO! Você perdeu 3 créditos extras de bateria.\n")
      }
      senao se (item == "$$$") 
      {
        tesouroEncontrado = verdadeiro
        escreva("💎 TESOURO ENCONTRADO! Você venceu o jogo!\n")
      }
      senao 
      {
        escreva("🌊 Casa vazia (---). Nada foi encontrado.\n")
      }
    }

    // 5. Encerramento e Resultado Final
    exibirResultado(nivelAtingido, tesouroEncontrado, totalRodadas)
  }

  // ---------- FUNÇÕES OBRIGATÓRIAS ----------

  funcao GerarCenario()
  {
    para (inteiro i = 0; i < 5; i++) 
    {
      para (inteiro j = 0; j < 5; j++) 
      {
        tabuleiro[i][j] = "---"
        tabuleiroVisivel[i][j] = "[ ~ ]"
      }
    }

    casaB05 = u.sorteia(1, 25)
    atribuirCasa(casaB05, "B05")

    faca 
    {
      casaB10 = u.sorteia(1, 25)
    } enquanto (casaB10 == casaB05)
    atribuirCasa(casaB10, "B10")

    faca 
    {
      casaRisco = u.sorteia(limiteNivel1 + 1, 25)
    } enquanto (casaRisco == casaB05 ou casaRisco == casaB10)
    atribuirCasa(casaRisco, "RIS")

    faca 
    {
      casaTesouro = u.sorteia(limiteNivel1 + 1, 25)
    } enquanto (casaTesouro == casaB05 ou casaTesouro == casaB10 ou casaTesouro == casaRisco)
    atribuirCasa(casaTesouro, "$$$")
  }

  funcao DiminuirBateria()
  {
    bateria = bateria - 10
  }

  funcao Bonus(inteiro valor)
  {
    bateria = bateria + valor
    bonusObtidos = bonusObtidos + valor
  }

  funcao Risco()
  {
    bateria = bateria - 3
  }

  // ---------- FUNÇÕES AUXILIARES ----------

  funcao atribuirCasa(inteiro casa, cadeia elemento)
  {
    inteiro l = (casa - 1) / 5
    inteiro c = (casa - 1) % 5
    tabuleiro[l][c] = elemento
  }

  funcao exibirTabuleiroVisivel()
  {
    escreva("\n      A      B      C      D      E\n")
    para (inteiro i = 0; i < 5; i++) 
    {
      escreva((i + 1), " ")
      para (inteiro j = 0; j < 5; j++) 
      {
        escreva(tabuleiroVisivel[i][j], "  ")
      }
      escreva("\n")
    }
  }

  funcao exibirResultado(cadeia nivelAtingido, logico tesouroEncontrado, inteiro totalRodadas)
  {
    escreva("\n========================================\n")
    escreva("            RESULTADO DO JOGO           \n")
    escreva("========================================\n")

    exibirTabuleiroVisivel()

    escreva("----------------------------------------\n")
    escreva("Bateria restante:     ", bateria, " créditos\n")
    escreva("Créditos obtidos:     ", bonusObtidos, " créditos\n")
    escreva("Nível atingido:       ", nivelAtingido, "\n")
    
    se (tesouroEncontrado) 
    {
      escreva("Tesouro encontrado:   SIM (VITÓRIA!)\n")
    } 
    senao 
    {
      escreva("Tesouro encontrado:   NÃO (BATERIA ESGOTADA)\n")
    }

    escreva("Posição do risco:     Casa: ", casaRisco, "\n")
    escreva("Quantidade de rodadas: ", totalRodadas, "\n")
    escreva("========================================\n")
  }
}