import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    id: item1
    width: 400
    height: 400
    property alias appVersionText: appVersionText
    property alias privacyPolicyTextAreaId: privacyPolicyTextAreaId
    property alias okButton: okButton
    property real policyOffset: 0.9

    ColumnLayout {
        id: column

        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width * policyOffset

        Text {
            id: appTitleText
            text: qsTr("Best To-Do List")
            font.bold: true
            font.family: "Times New Roman"
            font.pixelSize: 20
            Layout.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: appVersionText
            text: qsTr("Application version: ")
            font.pixelSize: 12
            Layout.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextArea {
            id: privacyPolicyTextAreaId
            Layout.topMargin: 10
            Layout.fillHeight: true
            readOnly: true
            font.pixelSize: 12
            textFormat: Text.RichText
            Layout.maximumWidth: parent.width
            wrapMode: TextEdit.WordWrap

            text: qsTr("<p><center><b>Privacy Policy</b></center><br>
                               Application collects and store only information entered directly by user: lists of tasks, their statuses and related additional data.
                               Application doesn't share collected information with any 3rd party.<br>
                               When you delete task record, it's completely erazed from the memory of device.</p> <br>
                               <a href=\"https://twitter.com/_max_go_\" >Twitter</a> <a href=\"https://ua.linkedin.com/in/maximrisukhin\" >LinkedIn</a>
                               <a href=\"http://stackoverflow.com/users/story/2266412\" >StackOverflow</a>")
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: appCopyrightsText
            text: qsTr("IProApps, Copyright 2017")
            font.pixelSize: 12
            Layout.topMargin: 10
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            id: okButton
            width: 50
            height: 20
            text: qsTr("OK")
            Layout.topMargin: 10
        }
    }
}
