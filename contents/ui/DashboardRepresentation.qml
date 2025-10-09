/*
    SPDX-FileCopyrightText: 2025 CAL <calamytymytryx@gmail.com>
    
    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.20 as Kirigami
import org.kde.ksvg 1.0 as KSvg
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.private.kicker 0.1 as Kicker

import "." as Local

Kicker.DashboardWindow {
    id: root

    backgroundColor: Qt.rgba(0, 0, 0, 0.3) // Semi-transparent background for visibility
    keyEventProxy: searchField

    onKeyEscapePressed: {
        if (searchField.text !== "") {
            searchField.clear();
        } else {
            root.toggle();
        }
    }

    onVisibleChanged: {
        if (visible) {
            searchField.forceActiveFocus();
        } else {
            searchField.text = "";
        }
    }

    function reset() {
        searchField.text = "";
        kicker.currentCategory = "All";
    }

    mainItem: Item {
        id: fullRep

        anchors.fill: parent

        // --- Add this MouseArea for outside click-to-close ---
        MouseArea {
            anchors.fill: parent
            z: 0
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            propagateComposedEvents: true
            onClicked: root.toggle()
        }
        // --- End addition ---

        Item {
            id: mainContainer
            z: 1

            // Make the container responsive to screen size
            width: Math.min(parent.width * 0.9, Kirigami.Units.gridUnit * 36)
            height: Math.min(parent.height * 0.9, Kirigami.Units.gridUnit * 35)
            anchors.centerIn: parent

            // Top categories outside the main container
            RowLayout {
                id: topCategoriesRow

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                // Make the top tabs overlap the background by adding bottom margin
                anchors.bottomMargin: -2
                // Negative margin creates overlap
                height: Kirigami.Units.gridUnit * 3
                spacing: Kirigami.Units.smallSpacing
                z: 100 // Ensure tabs are above the background

                // Top categories
                Repeater {
                    model: kicker.topCategories

                    Local.CategoryTab {
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                        categoryId: modelData.id
                        categoryName: modelData.name
                        categoryIcon: modelData.icon
                        isActive: kicker.currentCategory === modelData.id
                        onClicked: kicker.currentCategory = modelData.id

                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            border.color: "transparent"
                            border.width: 3
                            antialiasing: false

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 2
                                    color: "#f7f7f7"
                                }

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    width: 2
                                    color: "#f7f7f7"
                                }

                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 2
                                    color: "transparent"
                                }

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    width: 2
                                    color: "#2a2a2a"
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }
            }

            // Minecraft-style background
            Rectangle {
                id: backgroundRect

                // Adjust top anchor to allow tabs to overlap
                anchors.top: topCategoriesRow.bottom
                anchors.topMargin: -2
                anchors.left: parent.left
                anchors.right: parent.right
                // Adjust bottom anchor to allow bottom tabs to overlap
                anchors.bottom: bottomCategoriesRow.top
                anchors.bottomMargin: -2
                color: "#C6C6C6"
                z: 90 // Ensure background is below tabs but above other elements

                // Border container
                Item {
                    anchors.fill: parent
                    z: 95 // Make borders appear above background

                    // Top border
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 2
                        color: "#f7f7f7"
                        z: 96
                    }

                    // Left border
                    Rectangle {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        width: 2
                        color: "#f7f7f7"
                        z: 96
                    }

                    // Bottom border - make slightly thicker and ensure it's above other elements
                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 2
                        color: "#2a2a2a"
                        z: 9999999
                    }

                    // Right border - make slightly thicker and ensure it's above other elements
                    Rectangle {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        width: 2
                        color: "#2a2a2a"
                        z: 9999999
                    }
                }

                // Content container
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.smallSpacing * 2
                    spacing: Kirigami.Units.smallSpacing

                    // Search row inside the container
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.smallSpacing

                        Text {
                            text: kicker.currentCategory
                            font.pixelSize: searchField.height
                            color: "#404040"
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        // Search button/field
                        Rectangle {
                            Layout.preferredWidth: Kirigami.Units.gridUnit * 9
                            Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                            color: "#8B8B8B"
                            border.color: "#373737"
                            border.width: Kirigami.Units.devicePixelRatio * 2

                            TextField {
                                id: searchField

                                anchors.fill: parent
                                anchors.margins: Kirigami.Units.smallSpacing
                                color: "#FFFFFF"
                                font.pixelSize: searchField.height * 0.4
                                horizontalAlignment: Text.AlignHLeft
                                onTextChanged: kicker.searchText = text
                                
                                // Custom placeholder with image
                                placeholderTextColor: "transparent" // Hide default placeholder
                                
                                Item {
                                    anchors.fill: parent
                                    anchors.leftMargin: 2
                                    visible: !searchField.text // Only show when field is empty
                                    
                                    Row {
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: Kirigami.Units.smallSpacing
                                        
                                        Image {
                                            source: "../textures/ui/magnifyingGlass.png"
                                            width: searchField.height * 0.4
                                            height: width
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                        
                                        Text {
                                            text: "Search"
                                            color: "#FFFFFF"
                                            opacity: 0.6
                                            font.pixelSize: searchField.font.pixelSize
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }
                                }

                                background: Rectangle {
                                    color: "#000000"
                                    opacity: 0.4
                                }
                            }
                        }
                    }

                    // Inventory grid with custom scrollbar
                    Rectangle {
                        id: inventoryContainer

                        readonly property int scrollbarWidth: Kirigami.Units.gridUnit * 3.5 * 0.75
                        readonly property int separatorWidth: Kirigami.Units.gridUnit * 3.5 * 0.25
                        readonly property int gridAreaWidth: width - scrollbarWidth - separatorWidth
                        readonly property int favoriteBarHeight: Kirigami.Units.gridUnit * 3.5
                        readonly property int mainGridHeight: Kirigami.Units.gridUnit * 3.5 * 5
                        readonly property int userBarHeight: Kirigami.Units.gridUnit * 2.5
                        readonly property int itemsPerFavoritePage: 9 // Display 9 favorites per page

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#c6c6c6"

                        Local.StaticGrid {
                            id: staticGridDisplay

                            width: inventoryContainer.gridAreaWidth
                            height: inventoryContainer.mainGridHeight // Force exact height
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.margins: Kirigami.Units.smallSpacing
                        }

                        GridView {
                            id: gridView

                            // Force 9 columns
                            property int columns: 9

                            width: inventoryContainer.gridAreaWidth
                            height: inventoryContainer.mainGridHeight
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.margins: Kirigami.Units.smallSpacing
                            clip: true
                            model: kicker.getFilteredApps()
                            cellWidth: Kirigami.Units.gridUnit * 3.5
                            cellHeight: Kirigami.Units.gridUnit * 3.5
                            // Enable interaction on the GridView itself
                            interactive: true

                            // Make any change to contentY instantaneous
                            Behavior on contentY {
                                NumberAnimation {
                                    duration: 0
                                }
                            }

                            delegate: Local.InventorySlot {
                                appName: modelData.name
                                appIcon: modelData.icon
                                appExec: modelData.desktop
                                category: modelData.category || ""
                                appComment: modelData.comment || ""
                                isFavorite: kicker.isFavorite(modelData.desktop)
                                isFavoriteRow: false
                                onClicked: kicker.launchApp(appExec)
                                onRightClicked: kicker.toggleFavorite(appExec)
                            }
                        }

                        MouseArea {
                            width: gridView.width
                            height: gridView.height
                            anchors.left: gridView.left
                            anchors.top: gridView.top
                            acceptedButtons: Qt.NoButton
                            z: 10 // Ensure this is above other elements
                            onWheel: {
                                let newY = gridView.contentY;
                                if (wheel.angleDelta.y < 0)
                                    // Scroll down
                                    newY += gridView.cellHeight;
                                else if (wheel.angleDelta.y > 0)
                                    // Scroll up
                                    newY -= gridView.cellHeight;
                                // Clamp the position to prevent overscrolling
                                gridView.contentY = Math.max(0, Math.min(newY, gridView.contentHeight - gridView.height));
                            }
                        }

                        // User info and power controls bar
                        Rectangle {
                            id: userBar

                            width: Kirigami.Units.gridUnit * 3.5 * 9 // Exactly 9 inventory slots width
                            height: inventoryContainer.userBarHeight
                            anchors.left: parent.left
                            anchors.top: gridView.bottom
                            anchors.leftMargin: Kirigami.Units.smallSpacing
                            anchors.topMargin: Kirigami.Units.smallSpacing
                            color: "#c6c6c6"
                            z: 5 // Set z-index below the grid (10) but above background

                            RowLayout {
                                anchors.fill: parent
                                spacing: Kirigami.Units.smallSpacing

                                // User avatar image
                                Rectangle {
                                    id: avatarContainer
                                    Layout.preferredWidth: userBar.height - Kirigami.Units.smallSpacing * 2
                                    Layout.preferredHeight: userBar.height - Kirigami.Units.smallSpacing * 2
                                    Layout.leftMargin: Kirigami.Units.smallSpacing
                                    color: "#8B8B8B"
                                    
                                    // Default icon as fallback (shown when loading or error)
                                    Kirigami.Icon {
                                        id: fallbackIcon
                                        anchors.centerIn: parent
                                        width: parent.width * 0.8
                                        height: width
                                        source: Qt.resolvedUrl("../textures/ui/profile_glyph_combined.png")
                                        visible: avatarImage.status !== Image.Ready
                                    }
                                    
                                    Image {
                                        id: avatarImage
                                        anchors.fill: parent
                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        cache: false // Don't cache so it refreshes when config changes
                                        
                                        source: {
                                            // Get the custom avatar URL from configuration
                                            let customUrl = Plasmoid.configuration.customAvatarUrl || "";
                                            
                                            // Get the username from the data source
                                            let username = executable2.data["whoami"] ?
                                            executable2.data["whoami"]["stdout"].trim() : "User";
                                            
                                            // Use custom URL if provided, otherwise use MC heads
                                            if (customUrl && customUrl.trim() !== "") {
                                                return customUrl.trim();
                                            } else {
                                                return "https://mc-heads.net/avatar/" + username + "/100.png";
                                            }
                                        }
                                        
                                        onStatusChanged: {
                                            if (status === Image.Error) {
                                                console.log("Error loading avatar image. Falling back to default icon.");
                                            }
                                        }
                                    }
                                    
                                    // Add a border around the avatar
                                    Rectangle {
                                        anchors.fill: parent
                                        color: "transparent"
                                        
                                        Rectangle {
                                            anchors.top: parent.top
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            height: 2
                                            color: "#2a2a2a"
                                        }
                                        
                                        Rectangle {
                                            anchors.top: parent.top
                                            anchors.left: parent.left
                                            anchors.bottom: parent.bottom
                                            width: 2
                                            color: "#2a2a2a"
                                        }
                                        
                                        Rectangle {
                                            anchors.bottom: parent.bottom
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            height: 2
                                            color: "#f7f7f7"
                                        }
                                        
                                        Rectangle {
                                            anchors.top: parent.top
                                            anchors.right: parent.right
                                            anchors.bottom: parent.bottom
                                            width: 2
                                            color: "#f7f7f7"
                                        }
                                    }
                                }

                                // Username on the left
                                Text {
                                    text: executable2.data["whoami"] ? executable2.data["whoami"]["stdout"].trim() : "User"
                                    color: "#404040"
                                    font.pixelSize: parent.height * 0.4
                                    font.bold: true
                                    verticalAlignment: Text.AlignVCenter
                                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                }
                                Item {
                                    Layout.fillWidth: true
                                }

                                // Power controls on the right
                                Row {
                                    spacing: Kirigami.Units.smallSpacing
                                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                                    // Lock button
                                    Rectangle {
                                        width: userBar.height - Kirigami.Units.smallSpacing * 2
                                        height: width
                                        color: "#8B8B8B"

                                        Rectangle {
                                            anchors.fill: parent
                                            color: "transparent"

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                height: 2
                                                color: "#2a2a2a"
                                            }

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.left: parent.left
                                                anchors.bottom: parent.bottom
                                                width: 2
                                                color: "#2a2a2a"
                                            }

                                            Rectangle {
                                                anchors.bottom: parent.bottom
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                height: 2
                                                color: "#f7f7f7"
                                            }

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.right: parent.right
                                                anchors.bottom: parent.bottom
                                                width: 2
                                                color: "#f7f7f7"
                                            }
                                        }

                                        Kirigami.Icon {
                                            anchors.centerIn: parent
                                            width: parent.width * 0.6
                                            height: width
                                            source: Qt.resolvedUrl("../textures/ui/Lock.png")
                                            color: "#FFFFFF"
                                        }

                                        MouseArea {
                                            id: lockMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: executable2.connectSource("loginctl lock-session")
                                        }
                                    }

                                    // Logout button
                                    Rectangle {
                                        width: userBar.height - Kirigami.Units.smallSpacing * 2
                                        height: width
                                        color: "#8B8B8B"

                                        Rectangle {
                                            anchors.fill: parent
                                            color: "transparent"

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                height: 2
                                                color: "#2a2a2a"
                                            }

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.left: parent.left
                                                anchors.bottom: parent.bottom
                                                width: 2
                                                color: "#2a2a2a"
                                            }

                                            Rectangle {
                                                anchors.bottom: parent.bottom
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                height: 2
                                                color: "#f7f7f7"
                                            }

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.right: parent.right
                                                anchors.bottom: parent.bottom
                                                width: 2
                                                color: "#f7f7f7"
                                            }
                                        }
                                        Kirigami.Icon {
                                            anchors.centerIn: parent
                                            width: parent.width * 0.6
                                            height: width
                                            source: Qt.resolvedUrl("../textures/ui/Logout.png")
                                            color: "#FFFFFF"
                                        }

                                        MouseArea {
                                            id: logoutMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: Qt.openUrlExternally("qdbus org.kde.Shutdown /Shutdown logout")
                                        }
                                    }

                                    // Reboot button
                                    Rectangle {
                                        width: userBar.height - Kirigami.Units.smallSpacing * 2
                                        height: width
                                        color: "#8B8B8B"

                                        Rectangle {
                                            anchors.fill: parent
                                            color: "transparent"

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                height: 2
                                                color: "#2a2a2a"
                                            }

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.left: parent.left
                                                anchors.bottom: parent.bottom
                                                width: 2
                                                color: "#2a2a2a"
                                            }

                                            Rectangle {
                                                anchors.bottom: parent.bottom
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                height: 2
                                                color: "#f7f7f7"
                                            }

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.right: parent.right
                                                anchors.bottom: parent.bottom
                                                width: 2
                                                color: "#f7f7f7"
                                            }
                                        }

                                        Kirigami.Icon {
                                            anchors.centerIn: parent
                                            width: parent.width * 0.6
                                            height: width
                                            source: Qt.resolvedUrl("../textures/ui/Reboot.png")
                                            color: "#FFFFFF"
                                        }

                                        MouseArea {
                                            id: rebootMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: executable2.connectSource("systemctl reboot")
                                        }
                                    }

                                    // Shutdown button
                                    Rectangle {
                                        width: userBar.height - Kirigami.Units.smallSpacing * 2
                                        height: width
                                        color: "#8B8B8B"

                                        Rectangle {
                                            anchors.fill: parent
                                            color: "transparent"

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                height: 2
                                                color: "#2a2a2a"
                                            }

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.left: parent.left
                                                anchors.bottom: parent.bottom
                                                width: 2
                                                color: "#2a2a2a"
                                            }

                                            Rectangle {
                                                anchors.bottom: parent.bottom
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                height: 2
                                                color: "#f7f7f7"
                                            }

                                            Rectangle {
                                                anchors.top: parent.top
                                                anchors.right: parent.right
                                                anchors.bottom: parent.bottom
                                                width: 2
                                                color: "#f7f7f7"
                                            }
                                        }

                                        Kirigami.Icon {
                                            anchors.centerIn: parent
                                            width: parent.width * 0.6
                                            height: width
                                            source: Qt.resolvedUrl("../textures/ui/Shutdown.png")
                                            color: "#FFFFFF"
                                        }

                                        MouseArea {
                                            id: shutdownMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: executable2.connectSource("systemctl poweroff")
                                        }
                                    }
                                }
                            }
                        }

                        // Favorite app bar
                        Item {
                            id: favoriteContainer
                            width: inventoryContainer.gridAreaWidth
                            height: inventoryContainer.favoriteBarHeight
                            anchors.left: parent.left
                            anchors.top: userBar.bottom
                            anchors.leftMargin: Kirigami.Units.smallSpacing
                            anchors.topMargin: Kirigami.Units.smallSpacing

                            // Static favorite grid background
                            Local.StaticFavoriteGrid {
                                id: staticFavoriteGrid
                                anchors.fill: parent
                            }

                            // Favorite app slots - simplified to show first 9 favorites
                            Grid {
                                id: favoriteBar
                                width: parent.width
                                height: parent.height
                                anchors.centerIn: parent
                                columns: 9
                                
                                Repeater {
                                    model: 9 // Always show 9 slots
                                    
                                    Local.InventorySlot {
                                        property int favoriteIndex: index
                                        property string favoriteDesktopFile: favoriteIndex < kicker.favoriteApps.length ? 
                                                                           kicker.favoriteApps[favoriteIndex] : ""
                                        property var favoriteApp: favoriteDesktopFile ? kicker.getFavoriteAppData(favoriteDesktopFile) : null
                                        
                                        appName: favoriteApp ? favoriteApp.name : ""
                                        appIcon: favoriteApp ? favoriteApp.icon : ""
                                        appExec: favoriteApp ? favoriteApp.desktop : ""
                                        category: favoriteApp ? favoriteApp.category || "" : ""
                                        appComment: favoriteApp ? favoriteApp.comment || "" : ""
                                        isFavorite: favoriteApp !== null
                                        isFavoriteRow: true
                                        onClicked: {
                                            if (appExec)
                                                kicker.launchApp(appExec);
                                        }
                                        onRightClicked: {
                                            if (appExec)
                                                kicker.toggleFavorite(appExec);
                                        }
                                    }
                                }
                            }
                        }

                        // Separator wall
                        Rectangle {
                            id: separatorWall

                            width: inventoryContainer.separatorWidth
                            anchors.right: scrollbarArea.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            color: "#C6C6C6"
                        }

                        // Custom Scrollbar
                        Rectangle {
                            id: scrollbarArea

                            width: inventoryContainer.scrollbarWidth
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: favoriteContainer.bottom
                            anchors.topMargin: Kirigami.Units.smallSpacing
                            color: "#8b8b8b"

                            Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 2
                                color: "#2a2a2a"
                            }

                            Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                width: 2
                                color: "#2a2a2a"
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 2
                                color: "#f7f7f7"
                            }

                            Rectangle {
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                width: 2
                                color: "#f7f7f7"
                            }

                            Rectangle {
                                id: scrollbarHandle

                                width: parent.width * 0.92
                                height: Kirigami.Units.gridUnit * 3.5
                                color: "#838383"
                                anchors.horizontalCenter: parent.horizontalCenter
                                // Calculate Y position based on GridView's scroll with snapping
                                y: {
                                    let scrollableHeight = Math.max(1, gridView.contentHeight - gridView.height);
                                    let handleScrollableHeight = Math.max(1, scrollbarArea.height - height - 2 - 2); // Subtract 2 from top and 2 from bottom
                                    // Make sure position aligns with rows
                                    let rowPosition = Math.round(gridView.contentY / gridView.cellHeight);
                                    let snappedContentY = rowPosition * gridView.cellHeight;
                                    // Offset by 2 on top, -2 on bottom
                                    return 2 + Math.min(handleScrollableHeight, (snappedContentY / scrollableHeight) * handleScrollableHeight);
                                }

                                
                                // Draw 6 horizontal lines, spaced evenly, using a Repeater
                                Repeater {
                                    model: 7
                                    Rectangle {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: parent.width * 0.75
                                        height: parent.height * (1/7)
                                        y: parent.height * (1/7) * index
                                        color: "transparent"
                                        // Top line for all but the first
                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.top: parent.top
                                            height: 2
                                            color: "#505050"
                                            visible: index !== 0
                                        }
                                        // Bottom line for all but the last
                                        Rectangle {
                                            anchors.left: parent.left
                                            anchors.right: parent.right
                                            anchors.bottom: parent.bottom
                                            height: 2
                                            color: "#505050"
                                            visible: index !== (7)
                                        }
                                    }
                                }
                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 2
                                    color: "#f7f7f7"
                                }

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    width: 2
                                    color: "#f7f7f7"
                                }

                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 2
                                    color: "#2a2a2a"
                                }

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    width: 2
                                    color: "#2a2a2a"
                                }

                                MouseArea {
                                    // Track when dragging starts and ends
                                    property bool isDragging: false

                                    anchors.fill: parent
                                    drag.target: parent
                                    drag.axis: Drag.YAxis
                                    drag.minimumY: 2
                                    drag.maximumY: (scrollbarArea.height - parent.height) -2
                                    onPressed: isDragging = true
                                    onReleased: isDragging = false
                                    // Handle drag movement with row snapping
                                    onPositionChanged: {
                                        if (!isDragging)
                                            return ;

                                        let scrollableHeight = Math.max(1, gridView.contentHeight - gridView.height);
                                        let handleScrollableHeight = Math.max(1, scrollbarArea.height - parent.height);
                                        // Calculate the scroll ratio from the handle's drag position
                                        let scrollRatio = parent.y / handleScrollableHeight;
                                        let rawContentY = scrollRatio * scrollableHeight;
                                        // Snap to grid rows (like the mousewheel does)
                                        let rowPosition = Math.round(rawContentY / gridView.cellHeight);
                                        let snappedContentY = rowPosition * gridView.cellHeight;
                                        // Apply the snapped position to the GridView
                                        gridView.contentY = snappedContentY;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Bottom categories outside the main container
            RowLayout {
                id: bottomCategoriesRow

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                // Make the bottom tabs overlap the background by adding top margin
                anchors.topMargin: -2
                // Negative margin creates overlap
                height: Kirigami.Units.gridUnit * 3
                spacing: Kirigami.Units.smallSpacing
                z: 100 // Ensure tabs are above the background

                // Bottom categories
                Repeater {
                    model: kicker.bottomCategories

                    Local.CategoryTab {
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                        categoryId: modelData.id
                        categoryName: modelData.name
                        categoryIcon: modelData.icon
                        isActive: kicker.currentCategory === modelData.id
                        onClicked: kicker.currentCategory = modelData.id

                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            border.color: "transparent"
                            border.width: 3
                            antialiasing: false

                            Rectangle {
                                anchors.fill: parent
                                color: "transparent"

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 2
                                    color: "transparent"
                                }

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.bottom: parent.bottom
                                    width: 2
                                    color: "#f7f7f7"
                                }

                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 2
                                    color: "#2a2a2a"
                                }

                                Rectangle {
                                    anchors.top: parent.top
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    width: 2
                                    color: "#2a2a2a"
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                // Close button
                Rectangle {
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 3
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                    color: "#8B8B8B"
                    border.color: "#373737"
                    border.width: Kirigami.Units.devicePixelRatio * 2
                    anchors.topMargin: -2

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "transparent"
                        border.width: 3
                        antialiasing: false

                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"

                            Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 2
                                color: "transparent"
                            }

                            Rectangle {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.bottom: parent.bottom
                                width: 2
                                color: "#f7f7f7"
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 2
                                color: "#2a2a2a"
                            }

                            Rectangle {
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                width: 2
                                color: "#2a2a2a"
                            }
                        }
                    }

                    Image {
                        anchors.centerIn: parent
                        source: "../textures/ui/cancel.png"
                        width: parent.width * 0.6
                        height: width
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.toggle()
                        onEntered: parent.color = "#A0A0A0"
                        onExited: parent.color = "#8B8B8B"
                    }
                }
            }
        }
    }
}