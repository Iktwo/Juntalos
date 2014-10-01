#include <QApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>

#include "uivalues.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QCoreApplication::setOrganizationName("Iktwo");
    QCoreApplication::setOrganizationDomain("iktwo.com");
    QCoreApplication::setApplicationName("Juntalos");

    UIValues uiValues;
    engine.rootContext()->setContextProperty("ui", &uiValues);
    engine.load(QUrl(QStringLiteral("qrc:/qml/qml/main.qml")));

    return app.exec();
}

