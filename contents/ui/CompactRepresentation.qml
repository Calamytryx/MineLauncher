/*
    SPDX-FileCopyrightText: 2025 CAL <calamytymytryx@gmail.com>
    
    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.20 as Kirigami

import org.kde.plasma.private.kicker 0.1 as Kicker

Item {
    id: root

    readonly property bool vertical: (Plasmoid.formFactor === PlasmaCore.Types.Vertical)
    readonly property bool useCustomIcon: (Plasmoid.configuration.launcherIcon && Plasmoid.configuration.launcherIcon.length !== 0)

    readonly property Component dashWindowComponent: kicker.isDash ? Qt.createComponent(Qt.resolvedUrl("./DashboardRepresentation.qml"), root) : null
    readonly property Kicker.DashboardWindow dashWindow: dashWindowComponent && dashWindowComponent.status === Component.Ready
        ? dashWindowComponent.createObject(root, { visualParent: root }) : null

    onWidthChanged: updateSizeHints()
    onHeightChanged: updateSizeHints()

    function updateSizeHints() {
        const iconSize = Plasmoid.configuration.launcherIconSize || Kirigami.Units.iconSizes.large;
        root.Layout.minimumWidth = iconSize;
        root.Layout.minimumHeight = iconSize;
        root.Layout.maximumWidth = iconSize;
        root.Layout.maximumHeight = iconSize;
    }

    Kirigami.Icon {
        id: buttonIcon

        anchors.fill: parent

        active: mouseArea.containsMouse && !justOpenedTimer.running
        source: Plasmoid.configuration.launcherIcon || Qt.resolvedUrl("../minecraft-items/grass_block.png")

        onSourceChanged: root.updateSizeHints()
    }

    // Timer to prevent immediate re-opening
    Timer {
        id: justOpenedTimer
        interval: 250
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        property bool wasExpanded: false;

        activeFocusOnTab: true
        hoverEnabled: !root.dashWindow || !root.dashWindow.visible

        Keys.onPressed: {
            switch (event.key) {
            case Qt.Key_Space:
            case Qt.Key_Enter:
            case Qt.Key_Return:
            case Qt.Key_Select:
                Plasmoid.activated();
                break;
            }
        }
        Accessible.name: Plasmoid.title
        Accessible.description: "MC Inventory Launcher"
        Accessible.role: Accessible.Button

        onPressed: {
            if (!kicker.isDash) {
                wasExpanded = kicker.expanded
            }
        }

        onClicked: {
            if (kicker.isDash) {
                root.dashWindow.toggle();
                justOpenedTimer.start();
            } else {
                kicker.expanded = !wasExpanded;
            }
        }
    }

    Connections {
        target: Plasmoid
        enabled: kicker.isDash && root.dashWindow !== null

        function onActivated() {
            root.dashWindow.toggle();
            justOpenedTimer.start();
        }
    }
}