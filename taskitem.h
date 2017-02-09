#ifndef TASKITEM_H
#define TASKITEM_H

#include <QObject>
#include <QDateTime>

namespace model {

class TaskItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(bool done READ done WRITE setDone NOTIFY doneChanged)
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(int order READ order WRITE setOrder NOTIFY orderChanged)

public:
    explicit TaskItem(QObject *parent = 0);
    TaskItem(QString title, bool done, QString color, int order, QObject *parent = 0);
    TaskItem(const TaskItem& copy);

    QString title() const;
    void setTitle(QString title);

    bool done() const;
    void setDone(bool done);

    QString color() const;
    void setColor(QString color);

    int order() const;
    void setOrder(int order);

signals:

    void titleChanged();
    void doneChanged();
    void colorChanged(QString color);
    void orderChanged(int order);

private:

    QString m_title;
    bool m_done;
    QDateTime m_creationTime;
    QDateTime m_completeTime;
    QString m_color;
    int m_order;
};

} // namespace model

#endif // TASKITEM_H
