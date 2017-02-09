#include "taskitem.h"

namespace model {

TaskItem::TaskItem(QObject *parent) : QObject(parent)
  , m_done(false)
{

}

TaskItem::TaskItem(QString title, bool done, QString color, int order, QObject *parent) : QObject(parent)
  , m_title(title)
  , m_done(done)
  , m_color(color)
  , m_order(order)
{

}

TaskItem::TaskItem(const TaskItem &copy)
{
    m_title = copy.m_title;
    m_done = copy.m_done;
    m_color = copy.m_color;
    m_order = copy.m_order;
}

QString TaskItem::title() const
{
    return m_title;
}

void TaskItem::setTitle(QString title)
{
    if (m_title == title)
        return;

    m_title = title;
    emit titleChanged();
}

bool TaskItem::done() const
{
    return m_done;
}

void TaskItem::setDone(bool done)
{
    if (m_done == done)
        return;

    m_done = done;
    emit doneChanged();
}

void TaskItem::setColor(QString color)
{
    if (m_color == color)
        return;

    m_color = color;
    emit colorChanged(color);
}

QString TaskItem::color() const
{
    return m_color;
}

int TaskItem::order() const
{
    return m_order;
}

void TaskItem::setOrder(int order)
{
    if (m_order == order)
        return;

    m_order = order;
    emit orderChanged(order);
}

} // namespace model
