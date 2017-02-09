import QtQuick 2.4

AboutDialogForm {
    appVersionText.text: qsTr("Application version: ") + backend.appVersion()
    privacyPolicyTextAreaId.onLinkActivated: {
        Qt.openUrlExternally(link)
    }
}
