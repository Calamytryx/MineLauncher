import QtQuick
import org.kde.kirigami as Kirigami

Rectangle {
    id: tab
    
    property string categoryId: ""
    property string categoryName: ""
    property string categoryIcon: "application-x-executable"
    property bool isActive: false
    property bool hovered: false
    
    signal clicked()
    
    color: isActive ? "#C6C6C6" : "#8B8B8B"
    // Make active tabs appear above everything else
    z: isActive ? 200 : 100
    
    Behavior on color {
        ColorAnimation { duration: 100 }
    }
    
    // Icon
    Kirigami.Icon {
        anchors.centerIn: parent
        width: Kirigami.Units.iconSizes.medium
        height: Kirigami.Units.iconSizes.medium
        source: categoryIcon
        smooth: true
        color: "#000"
    }
    
    // Tooltip
    Rectangle {
        id: tooltip
        visible: hovered
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        anchors.bottomMargin: Kirigami.Units.smallSpacing
        width: tooltipText.width + Kirigami.Units.largeSpacing
        height: tooltipText.height + Kirigami.Units.smallSpacing
        color: "#3F3F3F"
        border.color: "#2A2A2A"
        border.width: Kirigami.Units.devicePixelRatio
        radius: Kirigami.Units.smallSpacing / 2
        z: 1000
        
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
            text: categoryName
            color: "#FFFFFF"
            font.pixelSize: Kirigami.Theme.smallFont.pixelSize
            font.family: "Monospace"
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: tab.clicked()
        onEntered: tab.hovered = true
        onExited: tab.hovered = false
    }
}
