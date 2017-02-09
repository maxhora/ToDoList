#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "backend.h"
#include "taskmodel.h"
#include "taskitem.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qRegisterMetaType<model::TaskItem*>("TaskItem*");
    qRegisterMetaType<Backend*>("Backend*");
    qmlRegisterType<model::TaskModel>("iproapps.besttodolist", 1, 0, "TaskModel");

    Backend backend;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("backend", &backend);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}
