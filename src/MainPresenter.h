#pragma once
#include <QtCore/QObject>
#include <QtCharts/QAbstractSeries>

#include <thread>
#include <mutex>

#include "Algorithms.h"

QT_CHARTS_USE_NAMESPACE

class MainPresenter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString expression   READ expression WRITE setExpression NOTIFY expressionChanged)
    Q_PROPERTY(double  leftEdge     READ leftEdge   WRITE setLeftEdge   NOTIFY leftEdgeChanged)
    Q_PROPERTY(double  rightEdge    READ rightEdge  WRITE setRightEdge  NOTIFY rightEdgeChanged)
    Q_PROPERTY(double  maxY         READ maxY       WRITE setMaxY       NOTIFY maxYChanged)
    Q_PROPERTY(double  minY         READ minY       WRITE setMinY       NOTIFY minYChanged)
    Q_PROPERTY(double  coff         READ coff       WRITE setCoff       NOTIFY coffChanged)
    Q_PROPERTY(quint64 stepsCnt     READ stepsCnt   WRITE setStepsCnt   NOTIFY stepsCntChanged)

public:
    MainPresenter();

    QString expression() const                      { return m_expression; };
    void setExpression(const QString& expression)   { m_expression = expression; }

    double leftEdge() const         { return m_range.first; };
    void setLeftEdge(double val)    { m_range.first = val; emit leftEdgeChanged(); }

    double rightEdge() const        { return m_range.second; };
    void setRightEdge(double val)   { m_range.second = val; emit rightEdgeChanged(); }

    double minY() const             { return m_range_y.first; };
    void setMinY(double val)        { m_range_y.first = val; emit minYChanged(); }

    double maxY() const             { return m_range_y.second; };
    void setMaxY(double val)        { m_range_y.second = val; emit maxYChanged(); }

    double coff() const             { return m_coff; };
    void setCoff(double val)        { m_coff = val; emit coffChanged(); }

    quint64 stepsCnt() const        { return m_iter_count; };
    void setStepsCnt(quint64 val)   { m_iter_count = val; emit stepsCntChanged(); }

public slots:
    void updateAllSeries(QAbstractSeries* func_s, QAbstractSeries* scan_s, QAbstractSeries* piya_s, QAbstractSeries* strong_s);

signals:
    void expressionChanged();
    void leftEdgeChanged();
    void rightEdgeChanged();
    void maxYChanged();
    void minYChanged();
    void coffChanged();
    void stepsCntChanged();

private:
    QString                     m_expression;
    std::pair<double, double>   m_range;
    std::pair<double, double>   m_range_y;
    size_t                      m_iter_count;
    double                      m_coff;

    void updateSeries(QAbstractSeries* series, BaseAlgorithm* alg, double level);

    std::mutex                          m_gui_change_mutex;
    std::unique_ptr<ScanAlgorithm>      m_scan_alg;
    std::unique_ptr<PiyavskiyAlgorithm> m_piya_alg;
    std::unique_ptr<StronginAlgorithm>  m_stong_alg;
};
