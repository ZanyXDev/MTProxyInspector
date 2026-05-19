// tests/auto/tst_boardgenerator/tst_testboardgenerator.h
#pragma once
#include <QtTest/QTest>
#include <QVector>
#include "boardgenerator.h"

class tst_BoardGenerator : public QObject
{
    Q_OBJECT  // ← MOC обработает этот макрос автоматически

private slots:
    void init();
    void cleanup();
    void testBoardSize_small();
    void testBoardSize_large();
    void testValidPairs_small();
    void testValidPairs_large();
    void testValueRange() const;
    void testSeedReproducibility();
    void testShuffleIsRandom() const;
    void testReturnIsCopy();    
private:
    bool validateCellPairs(const QVector<int>& cells, int expectedSize, int levelsSize);
    static constexpr int kLevelsSize = 48;
    BoardGenerator *m_generator;
};
