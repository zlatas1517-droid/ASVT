#include <math.h>
#include <immintrin.h>  // для AVX

extern "C" double func(int k, double x)
{
    // Оптимизация: предвычисление cos(x) один раз
    double cos_x = cos(x);

    // Оптимизация: обработка особых случаев
    if (cos_x == 0.0 || k < 0) return 0.0;

    // Оптимизация: вычисление факториала и степени в одном цикле
    double fact = 1.0;
    double x_pow = 1.0;

    // Размотка цикла на 4 итерации для Ryzen
    int k_aligned = k & ~3;
    int i = 1;

    // Основной цикл с размоткой
    for (; i <= k_aligned; i += 4)
    {
        fact *= (double)i;
        fact *= (double)(i + 1);
        fact *= (double)(i + 2);
        fact *= (double)(i + 3);

        x_pow *= x;
        x_pow *= x;
        x_pow *= x;
        x_pow *= x;
    }

    // Остаточный цикл
    for (; i <= k; i++)
    {
        fact *= (double)i;
        x_pow *= x;
    }

    // Оптимизация: вычисление с минимальным количеством операций
    // x^(-k) = 1.0 / (x^k)
    double ak;

    if (k % 2 == 0)
    {
        // Четная степень: возведение в квадрат для оптимизации
        double denom = fact * cos_x;
        ak = 1.0 / (x_pow * denom);
    }
    else
    {
        ak = 1.0 / (x_pow * fact * cos_x);
    }

    // abs с битовой операцией (быстрее чем условие)
    __m128d val = _mm_set_sd(ak);
    __m128d mask = _mm_set_sd(-0.0);
    val = _mm_andnot_pd(mask, val);
    ak = _mm_cvtsd_f64(val);

    return ak;
}