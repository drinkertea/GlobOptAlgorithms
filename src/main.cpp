#include <QApplication>
#include <QQmlApplicationEngine>
#include "MainPresenter.h"

static QObject *main_presenter_singletontype_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    MainPresenter *root = new MainPresenter();
    return root;
}

int main(int argc, char** argv)
{
    try
    {
        QApplication app(argc, argv);
        qmlRegisterSingletonType<MainPresenter>("Qt.lab.mainPresenterSingleton", 1, 0, "StepsMetods", main_presenter_singletontype_provider);
        QQmlApplicationEngine engine;
        engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
        return app.exec();
    }
    catch (...)
    {
        assert(false);
    }
    return 0;
}
