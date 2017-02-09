#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include "taskmodel.h"
#include "taskitem.h"

class Backend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QObject* newTaskModel READ newTaskModel NOTIFY newTaskModelChanged)
    Q_PROPERTY(QObject* doneTaskModel READ doneTaskModel NOTIFY doneTaskModelChanged)

public:
    explicit Backend(QObject *parent = 0);
    ~Backend();

    model::TaskModel* newTaskModel();
    model::TaskModel* doneTaskModel();

    Q_INVOKABLE void newTask(QString text, QString color);
    Q_INVOKABLE void deleteCompletedTask(model::TaskItem* task);
    Q_INVOKABLE QString appVersion();

signals:

    void newTaskModelChanged();
    void doneTaskModelChanged();

private slots:
    void scheduleSaveTasks();
    void taskStateChanged();

private:

    void saveTasks();
    void loadTasks();

    model::TaskModel m_newTaskModel;
    model::TaskModel m_doneTaskModel;

    QList<model::TaskItem*> m_taskList;
};

#endif // BACKEND_H
