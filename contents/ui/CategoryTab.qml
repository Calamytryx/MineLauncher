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
    
    color: isActive ? "#8B8B8B" : "#5B5B5B"
    border.color: "#373737"
    border.width: Kirigami.Units.devicePixelRatio * 2
    
    Behavior on color {
        ColorAnimation { duration: 100 }
    }
    
    // Inner highlight
    Rectangle {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.devicePixelRatio
        color: "transparent"
        border.color: isActive ? "#FFFFFF" : "#7B7B7B"
        border.width: Kirigami.Units.devicePixelRatio
        opacity: 0.5
    }
    
    // Icon
    Kirigami.Icon {
        anchors.centerIn: parent
        width: Kirigami.Units.iconSizes.medium
        height: Kirigami.Units.iconSizes.medium
        source: categoryIcon
        smooth: true
        color: "#FFFFFF"
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
        
        onEntered: {
            hovered = true
            if (!isActive) {
                tab.color = Qt.lighter(tab.color, 1.2)
            }
        }
        onExited: {
            hovered = false
            if (!isActive) {
                tab.color = "#5B5B5B"
            }
        }
        onClicked: tab.clicked()
    }
}
