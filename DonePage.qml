import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

import iproapps.besttodolist 1.0

DonePageForm {
    TaskListDelegateModel {
        id: delegateModelId
        visualModel.model: backend.doneTaskModel
        listView: parent.doneListView
    }

    doneListView.model: delegateModelId.visualModel
    doneListView.spacing: 4
}
