#include <stdio.h>
#include <math.h>
#include <omp.h>

#define G 6.67430e-11 // Constante gravitacional

// Declaração SIMD da função de cálculo de força
#pragma omp declare simd uniform(m1, m2)
double compute_force(double m1, double m2, double dx, double dy, double dz) {
    double distance_squared = dx * dx + dy * dy + dz * dz;
    double distance = sqrt(distance_squared);
    if (distance == 0.0) return 0.0; // Evita divisão por zero
    return (G * m1 * m2) / distance_squared;
}

int main() {
    const int N = 1000; // Número de corpos celestes
    double masses[N];
    double positions[N][3]; // Posições x, y, z
    double forces[N][3];    // Forças acumuladas em x, y, z

    // Inicializa as massas e posições
    for (int i = 0; i < N; i++) {
        masses[i] = 1.0e24; // Massa fictícia
        positions[i][0] = i * 1.0; // Posição x
        positions[i][1] = i * 2.0; // Posição y
        positions[i][2] = i * 3.0; // Posição z
    }

    // Inicializa as forças acumuladas com zero
    #pragma omp parallel for
    for (int i = 0; i < N; i++) {
        forces[i][0] = 0.0;
        forces[i][1] = 0.0;
        forces[i][2] = 0.0;
    }

    // Cálculo das forças gravitacionais entre pares de corpos
    #pragma omp parallel for simd collapse(2)
    for (int i = 0; i < N; i++) {
        for (int j = i + 1; j < N; j++) {
            double dx = positions[j][0] - positions[i][0];
            double dy = positions[j][1] - positions[i][1];
            double dz = positions[j][2] - positions[i][2];

            // Cálculo da força gravitacional
            double force = compute_force(masses[i], masses[j], dx, dy, dz);

            // Decomposição da força em x, y, z
            double fx = force * dx;
            double fy = force * dy;
            double fz = force * dz;

            // Atualização das forças
            #pragma omp atomic
            forces[i][0] -= fx;
            #pragma omp atomic
            forces[i][1] -= fy;
            #pragma omp atomic
            forces[i][2] -= fz;
            #pragma omp atomic
            forces[j][0] += fx;
            #pragma omp atomic
            forces[j][1] += fy;
            #pragma omp atomic
            forces[j][2] += fz;
        }
    }

    // Atualização das posições
    const double dt = 1.0; // Passo de tempo fictício
    #pragma omp parallel for
    for (int i = 0; i < N; i++) {
        positions[i][0] += forces[i][0] * dt / masses[i];
        positions[i][1] += forces[i][1] * dt / masses[i];
        positions[i][2] += forces[i][2] * dt / masses[i];
    }

    // Exibe as posições atualizadas para alguns corpos
    for (int i = 0; i < 10; i++) {
        printf("Body %d: Position (%f, %f, %f)\n", i, positions[i][0], positions[i][1], positions[i][2]);
    }

    return 0;
}
