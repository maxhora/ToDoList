#ifndef TASKMODEL_H
#define TASKMODEL_H

#include <QAbstractListModel>
#include <QDateTime>

#include "taskitem.h"

namespace model {

class TaskModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(int size READ size NOTIFY sizeChanged)

public:
    explicit TaskModel(QObject *parent = 0);
    ~TaskModel();

    enum Roles {
        TaskTextRole = Qt::UserRole + 1,
        TaskIsDoneRole,
        TaskIndexRole,
        ObjectRole
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    int size() const { return m_taskList.size(); }

    QHash<int, QByteArray> roleNames() const override;

    void addTask(TaskItem* task);
    bool takeTask(TaskItem* task);

signals:
    void sizeChanged(int arg);

private:

    void loadTasks();
    void saveTasks();

    QList<TaskItem*> m_taskList;
};

} // namespace model

#endif // TASKMODEL_H
