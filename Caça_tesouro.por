programa
{
	inclua biblioteca Tipos --> t
	inclua biblioteca Util --> u
	inclua biblioteca Matematica --> m

	// Estado Global do Jogo (Garante as assinaturas exatas das funções obrigatórias)
	cadeia tabuleiro[5][5]
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
		inteiro casaAtual = 0
		logico tesouroEncontrado = falso
		cadeia nivelAtingido = "I"

		real perc1, perc2, perc3
		real somaPerc

		// 1. Configuração dos Níveis e Validação
		faca 
		{
			escreva("========== CONFIGURAÇÃO DOS NÍVEIS ==========\n")
			escreva("Informe o percentual do Nível I (%): ")
			leia(perc1)
			escreva("Informe o percentual do Nível II (%): ")
			leia(perc2)
			escreva("Informe o percentual do Nível III (%): ")
			leia(perc3)

			somaPerc = perc1 + perc2 + perc3

			se (somaPerc != 100.0) 
			{
				escreva("\n[ERRO] A soma dos percentuais deve ser exatamente 100%! Tente novamente.\n\n")
			}
		} enquanto (somaPerc != 100.0)

		// 2. Cálculo dos Limites com Arredondamento sem aviso amarelo
		limiteNivel1 = t.real_para_inteiro(m.arredondar(25.0 * (perc1 / 100.0), 0))
		limiteNivel2 = t.real_para_inteiro(m.arredondar(25.0 * ((perc1 + perc2) / 100.0), 0))

		// 3. Geração do Cenário
		GerarCenario()

		// 4. Fluxo da Rodada
		enquanto (bateria >= 10 e nao tesouroEncontrado e casaAtual < 25)
		{
			// Reduz bateria na rodada
			DiminuirBateria()
			totalRodadas++

			inteiro linha = casaAtual / 5
			inteiro coluna = casaAtual % 5
			inteiro numeroCasa = casaAtual + 1

			// Registro do nível atingido
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

			// Processamento da casa
			cadeia conteudo = tabuleiro[linha][coluna]

			se (conteudo == "B05") 
			{
				Bonus(5)
			} 
			senao se (conteudo == "B10") 
			{
				Bonus(10)
			} 
			senao se (conteudo == "RIS") 
			{
				Risco()
			} 
			senao se (conteudo == "$$$") 
			{
				tesouroEncontrado = verdadeiro
			}

			casaAtual++
		}

		// 5. Encerramento e Resultado
		exibirResultado(nivelAtingido, tesouroEncontrado, totalRodadas)
	}

	// ---------- FUNÇÕES OBRIGATÓRIAS ----------

	funcao GerarCenario()
	{
		// 21 casas vazias (---)
		para (inteiro i = 0; i < 5; i++) 
		{
			para (inteiro j = 0; j < 5; j++) 
			{
				tabuleiro[i][j] = "---"
			}
		}

		// Sorteio B05 (qualquer nível)
		casaB05 = u.sorteia(1, 25)
		atribuirCasa(casaB05, "B05")

		// Sorteio B10 (qualquer nível, sem sobreposição)
		faca 
		{
			casaB10 = u.sorteia(1, 25)
		} enquanto (casaB10 == casaB05)
		atribuirCasa(casaB10, "B10")

		// Sorteio RIS (proibido no Nível I)
		faca 
		{
			casaRisco = u.sorteia(limiteNivel1 + 1, 25)
		} enquanto (casaRisco == casaB05 ou casaRisco == casaB10)
		atribuirCasa(casaRisco, "RIS")

		// Sorteio $$$ (proibido no Nível I, sem sobreposição)
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

	funcao exibirResultado(cadeia nivelAtingido, logico tesouroEncontrado, inteiro totalRodadas)
	{
		escreva("\n========================================\n")
		escreva("           RESULTADO DO JOGO            \n")
		escreva("========================================\n")

		para (inteiro i = 0; i < 5; i++) 
		{
			para (inteiro j = 0; j < 5; j++) 
			{
				escreva("[", tabuleiro[i][j], "] ")
			}
			escreva("\n")
		}

		escreva("----------------------------------------\n")
		escreva("Bateria restante:     ", bateria, " créditos\n")
		escreva("Créditos obtidos:     ", bonusObtidos, " créditos\n")
		escreva("Nível atingido:       ", nivelAtingido, "\n")
		
		se (tesouroEncontrado) 
		{
			escreva("Tesouro encontrado:   SIM\n")
		} 
		senao 
		{
			escreva("Tesouro encontrado:   NÃO\n")
		}

		escreva("Posição do risco:     Casa: ", casaRisco, "\n")
		escreva("Quantidade de rodadas: ", totalRodadas, "\n")
		escreva("========================================\n")
	}
}