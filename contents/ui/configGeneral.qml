import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.plasmoid 2.0
import org.kde.iconthemes 1.0 as KIconThemes

Item {
    id: root
    
    // Configuration properties
    property string cfg_launcherIcon: "start-here-kde"
    property int cfg_launcherIconSize: 48
    property bool cfg_alwaysExpanded: false
    property string cfg_customAvatarUrl: ""
    
    // Initialize from current configuration
    Component.onCompleted: {
        iconButton.iconSource = plasmoid.configuration.launcherIcon || "start-here-kde"
        iconSizeSpinBox.value = plasmoid.configuration.launcherIconSize || 48
        alwaysExpandedCheck.checked = plasmoid.configuration.alwaysExpanded || false
        customAvatarField.text = plasmoid.configuration.customAvatarUrl || ""
        
        // Update properties from initialized controls
        cfg_launcherIcon = iconButton.iconSource
        cfg_launcherIconSize = iconSizeSpinBox.value
        cfg_alwaysExpanded = alwaysExpandedCheck.checked
        cfg_customAvatarUrl = customAvatarField.text
    }
    
    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        
        // Icon Button
        Button {
            id: iconButton
            
            property string iconSource: "start-here-kde"
            
            Kirigami.FormData.label: "Launcher Icon:"
            icon.name: iconSource
            
            onClicked: iconDialog.open()
            
            onIconSourceChanged: {
                cfg_launcherIcon = iconSource
            }
            
            KIconThemes.IconDialog {
                id: iconDialog
                
                onIconNameChanged: {
                    if (iconName) {
                        iconButton.iconSource = iconName
                    }
                }
            }
        }
        
        // Icon size
        SpinBox {
            id: iconSizeSpinBox
            Kirigami.FormData.label: "Icon Size:"
            from: 16
            to: 256
            stepSize: 8
            
            onValueChanged: {
                cfg_launcherIconSize = value
            }
        }
        
        // Custom avatar URL
        TextField {
            id: customAvatarField
            Kirigami.FormData.label: "Custom Avatar URL:"
            placeholderText: "Leave empty to use mc-heads.net/avatar/{username}"
            
            onTextChanged: {
                cfg_customAvatarUrl = text
            }
        }
        
        Label {
            text: "Example: https://mc-heads.net/avatar/Steve/100.png"
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }
        
        // Always expanded option
        CheckBox {
            id: alwaysExpandedCheck
            Kirigami.FormData.label: "Always Expanded:"
            text: "Keep launcher always visible"
            
            onCheckedChanged: {
                cfg_alwaysExpanded = checked
            }
        }

        Label {
            text: "Note: Favorites are limited to 10 items maximum"
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            opacity: 0.7
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }
    }
}
