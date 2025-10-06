/*
    SPDX-FileCopyrightText: 2014 Eike Hein <hein@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.plasmoid 2.0
import org.kde.kcmutils as KCM
import org.kde.iconthemes as KIconThemes

KCM.SimpleKCM {
    id: configGeneral

    property string cfg_launcherIcon: Plasmoid.configuration.launcherIcon || "applications-all"
    property alias cfg_alwaysExpanded: alwaysExpandedCheckBox.checked

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        Button {
            id: iconButton

            Kirigami.FormData.label: i18n("Launcher Icon:")

            implicitWidth: Kirigami.Units.iconSizes.large + Kirigami.Units.smallSpacing * 2
            implicitHeight: Kirigami.Units.iconSizes.large + Kirigami.Units.smallSpacing * 2

            onPressed: iconDialog.open()

            Kirigami.Icon {
                anchors.centerIn: parent
                width: Kirigami.Units.iconSizes.large
                height: width
                source: configGeneral.cfg_launcherIcon || "applications-all"
            }

            KIconThemes.IconDialog {
                id: iconDialog
                onIconNameChanged: configGeneral.cfg_launcherIcon = iconName || "applications-all"
            }
        }

        Label {
            text: i18n("Choose an icon for the compact launcher representation.")
            font.italic: true
            wrapMode: Text.WordWrap
        }

        CheckBox {
            id: alwaysExpandedCheckBox
            Kirigami.FormData.label: i18n("Always Expanded:")
            text: i18n("Show full menu directly in horizontal panels")
        }

        Label {
            text: i18n("When enabled, the plasmoid will show the full menu in horizontal panels without requiring a click. In vertical panels, it remains compact.")
            font.italic: true
            wrapMode: Text.WordWrap
        }

    }
}
