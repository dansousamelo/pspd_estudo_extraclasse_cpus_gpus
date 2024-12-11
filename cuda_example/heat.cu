#include <cuda_runtime.h>
#include <iostream>
#include <vector>
#include <iomanip>

#define N 1024   // Tamanho da placa (N x N)
#define T 1000   // Número de iterações
#define BLOCK_SIZE 32  // Tamanho do bloco CUDA

__global__ void heat_kernel(float* d_plate, float* d_new_plate, int n) {
    __shared__ float shared_plate[BLOCK_SIZE + 2][BLOCK_SIZE + 2];

    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    int local_x = threadIdx.x + 1;
    int local_y = threadIdx.y + 1;

    if (x < n && y < n) {
        // Carregar a célula principal e vizinhos na memória compartilhada
        shared_plate[local_x][local_y] = d_plate[y * n + x];

        if (threadIdx.x == 0 && x > 0) // Carregar vizinho esquerdo
            shared_plate[0][local_y] = d_plate[y * n + x - 1];
        if (threadIdx.x == BLOCK_SIZE - 1 && x < n - 1) // Vizinho direito
            shared_plate[BLOCK_SIZE + 1][local_y] = d_plate[y * n + x + 1];
        if (threadIdx.y == 0 && y > 0) // Vizinho de cima
            shared_plate[local_x][0] = d_plate[(y - 1) * n + x];
        if (threadIdx.y == BLOCK_SIZE - 1 && y < n - 1) // Vizinho de baixo
            shared_plate[local_x][BLOCK_SIZE + 1] = d_plate[(y + 1) * n + x];

        __syncthreads();

        // Atualizar a célula usando a equação de calor
        if (x > 0 && x < n - 1 && y > 0 && y < n - 1) {
            d_new_plate[y * n + x] = (shared_plate[local_x - 1][local_y] +
                                      shared_plate[local_x + 1][local_y] +
                                      shared_plate[local_x][local_y - 1] +
                                      shared_plate[local_x][local_y + 1]) / 4.0;
        }
    }
}

void initialize_plate(std::vector<float>& plate, int n) {
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            if (i == 0) plate[i * n + j] = 100.0f; // Bordas superiores
            else plate[i * n + j] = 0.0f;         // Demais células
        }
    }
}

int main() {
    size_t size = N * N * sizeof(float);

    // Alocar memória na CPU
    std::vector<float> h_plate(N * N);
    initialize_plate(h_plate, N);

    // Alocar memória na GPU
    float* d_plate;
    float* d_new_plate;
    cudaMalloc(&d_plate, size);
    cudaMalloc(&d_new_plate, size);

    cudaMemcpy(d_plate, h_plate.data(), size, cudaMemcpyHostToDevice);

    dim3 threadsPerBlock(BLOCK_SIZE, BLOCK_SIZE);
    dim3 numBlocks(N / BLOCK_SIZE, N / BLOCK_SIZE);

    for (int t = 0; t < T; ++t) {
        heat_kernel<<<numBlocks, threadsPerBlock>>>(d_plate, d_new_plate, N);
        cudaDeviceSynchronize();

        // Trocar os ponteiros das placas
        std::swap(d_plate, d_new_plate);
    }

    cudaMemcpy(h_plate.data(), d_plate, size, cudaMemcpyDeviceToHost);

    // Imprimir uma pequena seção da placa
    for (int i = 0; i < 10; ++i) {
        for (int j = 0; j < 10; ++j) {
            std::cout << std::setw(8) << std::setprecision(2) << h_plate[i * N + j] << " ";
        }
        std::cout << "\n";
    }

    cudaFree(d_plate);
    cudaFree(d_new_plate);

    return 0;
}
