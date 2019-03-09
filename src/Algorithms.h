#pragma once
#include <string>
#include <vector>
#include <functional>

struct Interval
{
    double m_left;
    double m_right;

    Interval(double left = 0.0, double right = 0.0);
    double get_length() const;
    double get_middle();
    bool operator<(const Interval& r);
};

enum AlgType
{
    BaseAlgorithmType = 0,
    ScanAlgorithmType,
    PiyavskiyAlgorithmType,
    StronginAlgorithmType,
};

class BaseAlgorithm
{
protected:
    std::function<double(double)>   m_function;
    std::vector<Interval>           m_intervals;
    std::vector<double>             m_characteristics;
    size_t                          m_curr_max_ind;

    void        sort();
    void        reset_characteristics();
    void        split_intervals(size_t index);

    virtual AlgType get_type() { return BaseAlgorithmType; }
    virtual void reset_coffs() {}

    virtual double calc_character(size_t index) = 0;
    virtual double get_split_point(size_t index) = 0;

public:
    void        reset();
    double      get_function_value(double x);
    void        set_function(std::string function);
    Interval    get_interval(size_t index);
    void        initialize(double left, double right);
    size_t      size();
    void        make_new_interval();

    virtual void set_coff(double coff) {}
};

class ScanAlgorithm : public BaseAlgorithm
{
    virtual AlgType get_type() { return ScanAlgorithmType; }

public:
    virtual double calc_character(size_t index) override;
    virtual double get_split_point(size_t index) override;
};

class PiyavskiyAlgorithm : public BaseAlgorithm
{
    double m_coff = 0.0;
    virtual double calc_character(size_t index) override;
    virtual double get_split_point(size_t index) override;
    virtual AlgType get_type() { return PiyavskiyAlgorithmType; }
    virtual void reset_coffs() override { m_coff = 0.0; }

public:
    virtual void set_coff(double coff) override { m_coff = coff; }
};

class StronginAlgorithm : public BaseAlgorithm
{
    double m_M = 0.0;
    double m_m = 0.0;
    double m_r = 0.0;
    virtual double calc_character(size_t index) override;
    virtual double get_split_point(size_t index) override;
    virtual AlgType get_type() { return StronginAlgorithmType; }
    virtual void reset_coffs() override { m_M = m_m = m_r = 0.0; }

public:
    virtual void set_coff(double coff) override { m_r = coff; }
};
