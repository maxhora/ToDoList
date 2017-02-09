#include "backend.h"

#include <QSettings>
#include <QDebug>
#include <QtConcurrent>
#include <QMutex>
#include <QMutexLocker>

const QString APP_VERSION = "1.1.1.0";

QMutex gTaskListMutex;

Backend::Backend(QObject *parent) : QObject(parent)
{
    loadTasks();
}

Backend::~Backend()
{
    qDeleteAll(m_taskList);
    m_taskList.clear();
}

model::TaskModel* Backend::newTaskModel()
{
    return &m_newTaskModel;
}

model::TaskModel* Backend::doneTaskModel()
{
    return &m_doneTaskModel;
}

void Backend::newTask(QString text, QString color)
{
    QMutexLocker locker(&gTaskListMutex);
    model::TaskItem* task = new model::TaskItem(text, false, color, 0);
    connect(task, &model::TaskItem::doneChanged, this, &Backend::taskStateChanged);
    connect(task, &model::TaskItem::titleChanged, this, &Backend::scheduleSaveTasks);
    connect(task, &model::TaskItem::orderChanged, this, &Backend::scheduleSaveTasks);

    m_taskList.push_front(task);
    m_newTaskModel.addTask(task);
    scheduleSaveTasks();
}

void Backend::deleteCompletedTask(model::TaskItem *task)
{
    QMutexLocker locker(&gTaskListMutex);

    if (!task)
        return;

    if (m_doneTaskModel.takeTask(task)) {
        m_taskList.removeOne(task);
        scheduleSaveTasks();
    }
}

QString Backend::appVersion()
{
    return APP_VERSION;
}

void Backend::loadTasks()
{
    QMutexLocker locker(&gTaskListMutex);

    QSettings settings("IProApps", "BestToDoList");

    int size = settings.beginReadArray("todos");
    for (int i = 0; i < size; ++i) {
        settings.setArrayIndex(i);
        model::TaskItem* task = new model::TaskItem(settings.value("taskText").toString(), settings.value("isDone").toBool(),
                                                    settings.value("color").toString(), settings.value("order").toInt());
        connect(task, &model::TaskItem::doneChanged, this, &Backend::taskStateChanged);
        connect(task, &model::TaskItem::titleChanged, this, &Backend::scheduleSaveTasks);
        connect(task, &model::TaskItem::orderChanged, this, &Backend::scheduleSaveTasks);

        m_taskList.append(task);
    }
    settings.endArray();

    qSort(m_taskList.begin(), m_taskList.end(),
          [](model::TaskItem* a, model::TaskItem* b) -> bool { return a->order() < b->order(); });

    foreach (model::TaskItem* task, m_taskList) {
        if (task->done()) {
            m_doneTaskModel.addTask(task);
        } else {
            m_newTaskModel.addTask(task);
        }
    }

    qDebug() << "Loaded tasks: " << m_taskList.size();
}

void Backend::scheduleSaveTasks()
{
    QtConcurrent::run(this, &Backend::saveTasks);
}

void Backend::saveTasks()
{
    QMutexLocker locker(&gTaskListMutex);

    QSettings settings("IProApps", "BestToDoList");
    settings.beginWriteArray("todos");
    for (int i = 0; i < m_taskList.size(); ++i) {
        settings.setArrayIndex(i);
        settings.setValue("taskText", m_taskList.at(i)->title());
        settings.setValue("isDone", m_taskList.at(i)->done());
        settings.setValue("color", m_taskList.at(i)->color());
        settings.setValue("order", m_taskList.at(i)->order());
    }
    settings.endArray();

    qDebug() << "Saved tasks: " << m_taskList.size();
}

void Backend::taskStateChanged()
{
    model::TaskItem* task = qobject_cast<model::TaskItem*>(sender());
    if (!task)
        return;
    if (task->done()) {
        m_newTaskModel.takeTask(task);
        task->setOrder(m_doneTaskModel.size());
        m_doneTaskModel.addTask(task);
    } else {
        m_doneTaskModel.takeTask(task);
        task->setOrder(m_newTaskModel.size());
        m_newTaskModel.addTask(task);
    }

    scheduleSaveTasks();
}
