// tests/auto/tst_boardgenerator/tst_testboardgenerator.cpp
#include <QtTest/QTest>
#include <QtTest/QSignalSpy>
#include <QRandomGenerator>
#include <QSet>

// Подключаем тестируемый класс
#include "tst_testboardgenerator.h"

// -----------------------------------------------------------------------------
void tst_BoardGenerator::init()
{
    m_generator = new BoardGenerator();
}

void tst_BoardGenerator::cleanup()
{
    delete m_generator;
    m_generator = nullptr;
}

// -----------------------------------------------------------------------------
// Вспомогательная валидация
bool tst_BoardGenerator::validateCellPairs(const QVector<int>& cells, int expectedSize, int levelsSize)
{
    if (cells.size() != expectedSize) return false;

    std::array<int, 47> freq{};  // 0..46
    for (int val : cells) {
        if (val < 0 || val >= levelsSize) return false;
        if (++freq[val] > 2) return false;
    }

    int pairCount = 0;
    for (int count : freq) {
        if (count == 2) ++pairCount;
    }
    return pairCount == (expectedSize / 2);
}

// -----------------------------------------------------------------------------
void tst_BoardGenerator::testBoardSize_small()
{
    auto board = m_generator->generateBoard(true, 42);  // small = true, фиксированный seed
    QCOMPARE(board.size(), 12);
}

void tst_BoardGenerator::testBoardSize_large()
{
    auto board = m_generator->generateBoard(false, 42);  // small = false
    QCOMPARE(board.size(), 16);
}

void tst_BoardGenerator::testValidPairs_small()
{
    auto board = m_generator->generateBoard(true, 0);  // random seed
    QVERIFY(validateCellPairs(board, 12, kLevelsSize));
}

void tst_BoardGenerator::testValidPairs_large()
{
    auto board = m_generator->generateBoard(false, 0);
    QVERIFY(validateCellPairs(board, 16, kLevelsSize));
}

void tst_BoardGenerator::testValueRange() const
{
    // Запускаем много итераций для статистической уверенности
    for (int i = 0; i < 100; ++i) {
        auto board = m_generator->generateBoard(false, 0);
        for (const int val : board) {
            QVERIFY2(val >= 0 && val < kLevelsSize,
                     qPrintable(QString("Value %1 out of [0, %2)").arg(val).arg(kLevelsSize)));
        }
    }
}

void tst_BoardGenerator::testSeedReproducibility()
{
    const quint32 seed = 12345;

    auto board1 = m_generator->generateBoard(true, seed);
    auto board2 = m_generator->generateBoard(true, seed);

    // Одинаковый seed → одинаковый результат
    QCOMPARE(board1, board2);

    // Другой seed → другой результат (с высокой вероятностью)
    auto board3 = m_generator->generateBoard(true, seed + 1);
    QVERIFY(board1 != board3);
}

void tst_BoardGenerator::testShuffleIsRandom() const
{
    // Проверяем, что перемешивание действительно меняет порядок
    // (не тривиальный тест, но ловит ошибки типа "забыли вызвать shuffle")

    QSet<QString> seenPatterns;
    const int iterations = 50;

    for (int i = 0; i < iterations; ++i) {
        auto board = m_generator->generateBoard(false, 0);  // random seed
        // Преобразуем в строку для сравнения паттернов
        QString pattern;
        pattern.reserve(board.size() * 3);
        for (const int val : board) {
            pattern += QString::number(val) + ',';
        }
        seenPatterns.insert(pattern);
    }

    // С высокой вероятностью получим >1 уникального паттерна
    QVERIFY2(seenPatterns.size() > 1,
             qPrintable(QString("Only %1 unique pattern(s) in %2 iterations - shuffle may be broken")
                            .arg(seenPatterns.size()).arg(iterations)));
}


void tst_BoardGenerator::testReturnIsCopy()
{
    // Проверяем, что возврат по значению не ломает инкапсуляцию
    // Генерируем доску
    auto board1 = m_generator->generateBoard(true, 42);

    // Получаем размер до модификации
    const int originalValue = board1[0];

    // Модифицируем локальную копию
    board1[0] = -999;

    // Генерируем заново с тем же seed → должен получить исходные данные
    auto board2 = m_generator->generateBoard(true, 42);

    // ✅ Проверяем:
    // 1. board2[0] не равен -999 (независимая копия)
    // 2. board2[0] равен исходному значению (воспроизводимость)
    QVERIFY2(board2[0] != -999, "Return value should be a copy, not a reference");
    QCOMPARE(board2[0], originalValue);

    // ✅ Дополнительно: размеры должны совпадать
    QCOMPARE(board1.size(), board2.size());
}

// -----------------------------------------------------------------------------
QTEST_MAIN(tst_BoardGenerator)
