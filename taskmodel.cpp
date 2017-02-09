#include "taskmodel.h"

#include <QSettings>
#include <QDebug>

namespace model {

TaskModel::TaskModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

TaskModel::~TaskModel()
{
    m_taskList.clear();
}

int TaskModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_taskList.size();
}

QVariant TaskModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if ((index.row() >= 0 || index.row() < m_taskList.count()) ) {
        if (role == TaskTextRole) {
            return m_taskList[index.row()]->title();
        } else if (role == TaskIsDoneRole) {
            return m_taskList[index.row()]->done();
        } else if (role == TaskIndexRole) {
            return index.row();
        } else if (role == ObjectRole) {
            return QVariant::fromValue((QObject*)m_taskList[index.row()]);
        }
    }

    return QVariant();
}

QHash<int, QByteArray> TaskModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TaskTextRole] = "taskText";
    roles[TaskIsDoneRole] = "isDone";
    roles[TaskIndexRole] = "taskIndex";
    roles[ObjectRole] = "object";
    return roles;
}

void TaskModel::addTask(TaskItem *task)
{
    for(int i = task->order(); i < size(); ++i) {
        m_taskList.at(i)->setOrder(i+1);
    }

    beginInsertRows(QModelIndex(), task->order(), task->order());
    m_taskList.insert(task->order(), task);
    endInsertRows();

    sizeChanged(size());
}

bool TaskModel::takeTask(TaskItem *task)
{
    if (m_taskList.contains(task)) {

        for(int i = task->order() + 1; i < size(); ++i) {
            m_taskList.at(i)->setOrder(i-1);
        }

        beginRemoveRows(QModelIndex(), m_taskList.indexOf(task), m_taskList.indexOf(task));
        m_taskList.removeOne(task);
        endRemoveRows();

        sizeChanged(size());
        return true;
    } else {
        return false;
    }
}

} // namespace model
