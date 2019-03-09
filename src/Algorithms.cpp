#include "Algorithms.h"
#include "3rdparty/exprtk.hpp"

#include <map>
#include <cassert>

Interval::Interval(double left, double right)
{
    m_left = left;
    m_right = right;
}

double Interval::get_length() const
{
    return std::abs(m_right - m_left);
}

double Interval::get_middle()
{
    return 0.5 * (m_right + m_left);
}

bool Interval::operator<(const Interval& r)
{
    return m_left < r.m_left;
}

class Expression
{
    exprtk::symbol_table<double> m_symbol_table;
    exprtk::expression<double>   m_expression;
    exprtk::parser<double>       m_parser;
    double m_value;

public:
    explicit Expression(const std::string& f = "")
    {
        m_symbol_table.add_variable("x", m_value);
        m_symbol_table.add_constants();
        m_expression.register_symbol_table(m_symbol_table);
        m_parser.compile(f, m_expression);
    }

    double get_value(double x)
    {
        m_value = x;
        return m_expression.value();
    }
};

// used to hide #include "exprtk.hpp" into cpp
static std::map<std::pair<AlgType, std::string>, std::shared_ptr<Expression>> g_expressions;

double BaseAlgorithm::get_function_value(double x)
{
    return m_function(x);
}

void BaseAlgorithm::set_function(std::string function)
{
    auto key_pair = std::make_pair(get_type(), function);
    auto it = g_expressions.find(key_pair);
    if (it == g_expressions.end())
    {
        const auto& val = g_expressions.emplace(key_pair, std::make_unique<Expression>(function));
        assert(val.second);
        it = val.first;
    }

    std::weak_ptr<Expression> expr = it->second;
    m_function = [expr](double x) {
        if (expr.expired())
            return 0.0;
        return expr.lock()->get_value(x);
    };
}

Interval BaseAlgorithm::get_interval(size_t index)
{
    return m_intervals[index];
}

void BaseAlgorithm::initialize(double left, double right)
{
    m_intervals.emplace_back(Interval(left, right));
    reset_characteristics();
}

size_t BaseAlgorithm::size()
{
    return m_intervals.size();
}

void BaseAlgorithm::sort()
{
    std::sort(m_intervals.begin(), m_intervals.end());
}

void BaseAlgorithm::reset()
{
    m_curr_max_ind = 0;
    m_intervals.clear();
    m_characteristics.clear();
    reset_coffs();
}

void BaseAlgorithm::reset_characteristics()
{
    m_characteristics.clear();
    m_characteristics.reserve(m_intervals.size());
    m_curr_max_ind = 0;
    for (size_t i = 0; i < m_intervals.size(); ++i)
    {
        m_characteristics.emplace_back(calc_character(i));
        if (m_characteristics.back() > m_characteristics[m_curr_max_ind])
            m_curr_max_ind = i;
    }
}

void BaseAlgorithm::split_intervals(size_t index)
{
    Interval first(m_intervals[index].m_left, get_split_point(index));
    Interval second(first.m_right, m_intervals[index].m_right);
    m_intervals[index] = second;
    m_intervals.emplace(m_intervals.begin() + index, std::move(first));
    reset_characteristics();
}

void BaseAlgorithm::make_new_interval()
{
    split_intervals(m_curr_max_ind);
}

double ScanAlgorithm::calc_character(size_t index)
{
    return m_intervals[index].get_length();
}

double ScanAlgorithm::get_split_point(size_t index)
{
    return m_intervals[index].get_middle();
}

double PiyavskiyAlgorithm::calc_character(size_t index)
{
    return 0.5 * m_coff * ((m_intervals[index].m_right - m_intervals[index].m_left) -
        (get_function_value(m_intervals[index].m_right) + get_function_value(m_intervals[index].m_left)) / 2.0);
}

double PiyavskiyAlgorithm::get_split_point(size_t index)
{
    return 0.5 * (m_intervals[index].m_right + m_intervals[index].m_left) -
        (get_function_value(m_intervals[index].m_right) - get_function_value(m_intervals[index].m_left)) / (2.0 * m_coff);
}

double StronginAlgorithm::calc_character(size_t index)
{
    double delta_x = m_intervals[index].m_right - m_intervals[index].m_left;
    double l_f = get_function_value(m_intervals[index].m_left);
    double r_f = get_function_value(m_intervals[index].m_right);
    double delta_f = r_f - l_f;
    double curr_M = std::abs(delta_f) / delta_x;
    if (curr_M > m_M)
        m_M = curr_M;
    if (m_M > 0.0)
        m_m = m_r * m_M;
    else
        m_m = 1.0;
    return m_m * delta_x + std::pow(delta_f, 2.0) / (m_m * delta_x) - 2.0 * (r_f + l_f);
}

double StronginAlgorithm::get_split_point(size_t index)
{
    return 0.5*(m_intervals[index].m_right + m_intervals[index].m_left) -
        (get_function_value(m_intervals[index].m_right) - get_function_value(m_intervals[index].m_left)) / (2.0 * m_m);
}
