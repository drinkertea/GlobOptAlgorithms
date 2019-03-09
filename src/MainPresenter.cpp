#include <QtCharts/QSplineSeries>
#include <QtCharts/QScatterSeries>

#include "MainPresenter.h"
#include "Algorithms.h"

MainPresenter::MainPresenter()
{
    m_expression = "cos(3.14159 * x) + sin(x)";
    m_range.second = 10;
    m_range_y = std::make_pair(0.0, 4.0);
    m_iter_count = 256;
    m_coff = 1.5;

    m_scan_alg = std::make_unique<ScanAlgorithm>();
    m_piya_alg = std::make_unique<PiyavskiyAlgorithm>();
    m_stong_alg = std::make_unique<StronginAlgorithm>();
}

void MainPresenter::updateAllSeries(QAbstractSeries* func_s, QAbstractSeries* scan_s, QAbstractSeries* piya_s, QAbstractSeries* strong_s)
{
    if (!func_s || !scan_s || !piya_s || !strong_s || !m_scan_alg || !m_piya_alg || !m_stong_alg)
        return;

    std::thread update_thread_1([&]() { updateSeries(scan_s,    static_cast<BaseAlgorithm*>(m_scan_alg.get()), -1.0); });
    std::thread update_thread_2([&]() { updateSeries(piya_s,    static_cast<BaseAlgorithm*>(m_piya_alg.get()),  0.0); });
    std::thread update_thread_3([&]() { updateSeries(strong_s,  static_cast<BaseAlgorithm*>(m_stong_alg.get()), 1.0); });

    QSplineSeries *spline_series = static_cast<QSplineSeries*>(func_s);
    spline_series->clear();
    QList<QPointF> points;

    update_thread_1.join();

    points.reserve(m_scan_alg->size() + 1);
    double min = 0.0, max = 0.0;
    const auto process_point = [&](double x)
    {
        points.push_back(QPointF(x, m_scan_alg->get_function_value(x)));
        min = std::min(min, points.back().y());
        max = std::max(max, points.back().y());
    };
    for (size_t i = 0; i < m_scan_alg->size(); ++i)
        process_point(m_scan_alg->get_interval(i).m_left);
    process_point(m_scan_alg->get_interval(m_scan_alg->size() - 1).m_right);
    setMaxY(std::round((max + 0.1) * 10.0) / 10.0);
    setMinY(std::round((min - 0.1) * 10.0) / 10.0);

    spline_series->append(points);

    update_thread_2.join();
    update_thread_3.join();
}

void MainPresenter::updateSeries(QAbstractSeries* series, BaseAlgorithm* alg, double level)
{
    QScatterSeries *scatter_series = static_cast<QScatterSeries*>(series);
    {
        std::lock_guard<std::mutex> lg(m_gui_change_mutex);
        scatter_series->clear();
        alg->reset();
        alg->set_function(m_expression.toStdString());
        alg->set_coff(m_coff);
        alg->initialize(m_range.first, m_range.second);
    }

    for (size_t i = 0; i < m_iter_count; ++i)
        alg->make_new_interval();
    QList<QPointF> points;
    points.reserve(alg->size() + 1);
    for (size_t i = 0; i < alg->size(); ++i)
        points.push_back(QPointF(alg->get_interval(i).m_left, level));
    points.push_back(QPointF(alg->get_interval(alg->size() - 1).m_right, level));

    {
        std::lock_guard<std::mutex> lg(m_gui_change_mutex);
        scatter_series->append(points);
    }
}