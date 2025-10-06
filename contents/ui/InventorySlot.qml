import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Item {
    id: slot
    
    property string appName: ""
    property string appIcon: ""
    property string appExec: ""
    property bool hovered: false
    property bool isFavorite: false
    property bool isFavoriteRow: false
    
    signal clicked()
    signal rightClicked()
    
    width: Kirigami.Units.gridUnit * 3.5
    height: Kirigami.Units.gridUnit * 3.5
    
    // Slot background
    Rectangle {
        id: slotBg
        anchors.fill: parent
        color: "transparent"
        
        Behavior on color {
            ColorAnimation { duration: 100 }
        }
        
        // Inner rectangle
        Rectangle {
            id: innerBorders
            anchors.fill: parent
            anchors.margins: 1  // Small margin to avoid overlap with parent border
            color: "#8B8B8B"
            
        }
        // App icon
        Kirigami.Icon {
            anchors.centerIn: parent
            width: Kirigami.Units.iconSizes.large
            height: Kirigami.Units.iconSizes.large
            source: appIcon
            smooth: true
        }
        
        // Favorite star indicator (only show if not in favorite row)
        Text {
            visible: isFavorite && !isFavoriteRow
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Kirigami.Units.smallSpacing / 2
            text: "⭐"
            font.pixelSize: Kirigami.Units.gridUnit * 0.7
            z: 10
        }
        
        // Hover tooltip
        Rectangle {
            id: tooltip
            visible: hovered && appName !== ""
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Kirigami.Units.smallSpacing
            width: tooltipText.width + Kirigami.Units.largeSpacing
            height: tooltipText.height + Kirigami.Units.smallSpacing
            color: "#3F3F3F"
            border.color: "#2A2A2A"
            border.width: Kirigami.Units.devicePixelRatio
            radius: Kirigami.Units.smallSpacing / 2
            z: 999999
            
            Rectangle {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.devicePixelRatio
                color: "transparent"
                border.color: "#5F5F5F"
                border.width: Kirigami.Units.devicePixelRatio
                radius: Kirigami.Units.smallSpacing / 2
            }
            
            Text {
                id: tooltipText
                anchors.centerIn: parent
                text: appName
                color: "#FFFFFF"
                font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                font.family: "Monospace"
            }
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onEntered: hovered = true
        onExited: hovered = false
        onClicked: function(mouse) {
            if (mouse.button === Qt.RightButton) {
                slot.rightClicked()
            } else {
                slot.clicked()
            }
        }
    }
}
