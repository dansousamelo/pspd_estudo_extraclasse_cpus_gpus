# 🌌 Cálculo de Força Gravitacional com OpenMP SIMD

Este projeto implementa um sistema de simulação física para calcular a força gravitacional entre corpos celestes. Ele usa **OpenMP** e diretivas SIMD para otimizar os cálculos, explorando o paralelismo de dados e multithreading.

---

## 📜 Enunciado do Problema

Você é contratado para implementar um sistema de simulação física que calcula a força gravitacional entre corpos celestes em um sistema solar fictício. Seu objetivo é otimizar os cálculos usando as diretivas SIMD do OpenMP para aproveitar o paralelismo de dados.

O sistema deve calcular:

1. As forças gravitacionais entre `N` corpos celestes.
2. Atualizar as posições desses corpos após aplicar as forças.

O código utiliza as principais diretivas SIMD do OpenMP:

- `#pragma omp simd`: Vetoriza loops explicitamente.
- `#pragma omp declare simd`: Declara funções otimizadas para execução SIMD.
- `#pragma omp parallel for simd`: Paraleliza e vetoriza loops aninhados.

---

## 🛠️ Como Compilar

Certifique-se de que o compilador GCC 14 está instalado e suporta OpenMP.

1. **Salvar o código em um arquivo**:
   Salve o código em um arquivo chamado `simd_gravity.c`.

2. **Compilar o código**:
   Use o seguinte comando para compilar:

   ```bash
   gcc -fopenmp -o simd_gravity simd_gravity.c -lm
   ```

   - `-fopenmp`: Ativa o suporte ao OpenMP.
   - `-lm`: Inclui a biblioteca matemática para funções como `sqrt`.

---

## 🚀 Como Executar

Após a compilação, execute o programa com:

```bash
./simd_gravity
```

Se desejar limitar o número de threads utilizados, defina a variável de ambiente `OMP_NUM_THREADS`:

```bash
export OMP_NUM_THREADS=4
./simd_gravity
```

---

## 🧪 Saída Esperada

A saída exibirá as posições atualizadas de alguns corpos celestes:

```
Body 0: Position (0.000000, 0.000000, 0.000000)
Body 1: Position (0.000001, 0.000002, 0.000003)
Body 2: Position (0.000004, 0.000008, 0.000012)
...
```

---

## 📚 Informações Relevantes

- **Diretivas SIMD Utilizadas**:

  - `#pragma omp simd`: Vetorização explícita.
  - `#pragma omp declare simd`: Declara funções vetorizadas.
  - `#pragma omp parallel for simd`: Combina multithreading e vetorização.

- **Constantes do Código**:

  - Constante gravitacional: `G = 6.67430e-11`.

---

## 📝 Licença

Este projeto é disponibilizado sob a [Licença MIT](LICENSE).

---
