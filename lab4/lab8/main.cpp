#include <iostream>
#include <locale>
#include <chrono>
#include <xmmintrin.h>  // для _mm_mfence

using namespace std;
using namespace std::chrono;

extern "C" double Sum(int n, double x);

// Оптимизация: выравнивание стека и предварительное резервирование
__declspec(align(64)) double result_cache = 0.0;

int main()
{
    setlocale(LC_ALL, "Russian");

    // Оптимизация: отключение синхронизации с stdio
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int n;
    double x;

    cout << "ВЫЧИСЛЕНИЕ СУММЫ РЯДА\n\n";
    cout << "Введите x: ";
    cin >> x;

    cout << "Введите n: ";
    cin >> n;

    // Оптимизация: выравнивание времени измерения
    _mm_mfence();  // барьер памяти для точного измерения

    auto start = high_resolution_clock::now();

    // Оптимизация: размотка цикла для 100000 итераций
    double result = 0.0;
    int iterations = 100000;
    int iterations_aligned = iterations & ~3;
    int i = 0;

    // Размотанный цикл на 4 итерации
    for (; i < iterations_aligned; i += 4)
    {
        result += Sum(n, x);
        result += Sum(n, x);
        result += Sum(n, x);
        result += Sum(n, x);
    }

    // Остаточный цикл
    for (; i < iterations; i++)
    {
        result += Sum(n, x);
    }

    // Нормализация результата (деление на количество итераций)
    result /= iterations;
    result_cache = result;  // сохранение в выровненную память

    auto finish = high_resolution_clock::now();

    // Оптимизация: барьер памяти перед чтением времени
    _mm_mfence();

    auto time = duration_cast<microseconds>(finish - start);

    cout << "\nСумма ряда = " << result_cache << endl;
    cout << "Время выполнения: " << time.count() << " мкс" << endl;
    cout << "Среднее время на итерацию: " << (double)time.count() / iterations << " мкс" << endl;

    return 0;
}