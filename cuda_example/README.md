# 🔥 CUDA Heat Simulation

Este projeto implementa uma simulação de propagação de calor em uma placa metálica 2D usando CUDA. Ele calcula a distribuição de temperatura após várias iterações, utilizando a equação de calor discreta.

## 📋 Pré-requisitos

Antes de começar, você precisa ter:

- **CUDA Toolkit** instalado.
- Um **ambiente com suporte a GPUs NVIDIA**.
- **Compilador NVCC** para compilar o código CUDA.

## 📂 Estrutura do Projeto

```
.
├── heat.cu          # Código-fonte principal
├── README.md        # Este arquivo
```

## 🚀 Como Rodar

1. **Clone o repositório:**

   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd <PASTA_DO_REPOSITORIO>
   ```

2. **Compile o código CUDA:**

   ```bash
   nvcc heat.cu -o heat_simulation
   ```

3. **Execute o programa:**

   ```bash
   ./heat_simulation
   ```

4. **Saída esperada:**

   O programa exibirá uma pequena seção da placa após as iterações. Por exemplo:

   ```
       100.00   100.00   100.00    ...
        50.00    75.00    80.00    ...
        ...
   ```

## 🛠️ Personalizações

Você pode ajustar:

- **Dimensão da placa**: Altere a constante `N` no código para definir o tamanho da matriz.
- **Número de iterações**: Modifique a constante `T` para alterar o número de passos de simulação.
- **Condições de temperatura**: Atualize a função `initialize_plate` para configurar condições iniciais diferentes.

## 🐛 Solução de Problemas

- **Erro de compilação**: Certifique-se de que o CUDA Toolkit está instalado e configurado corretamente.
- **Desempenho baixo**: Ajuste o tamanho do bloco CUDA (`BLOCK_SIZE`) para melhor utilização dos recursos da GPU.

## 📖 Referências

- [Documentação do CUDA Toolkit](https://docs.nvidia.com/cuda/)
- [Introdução ao CUDA](https://developer.nvidia.com/cuda-zone)

## 📄 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
