/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.2
import QtLocation 5.0
import QtPositioning 5.2
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0


Page {
    id: mapPage
    backNavigation: false
    SilicaFlickable{
        anchors.fill: parent
        PositionSource {
            id: src
            updateInterval: 1000
            active: true
        }

        Map{
            id: map
            anchors {left: parent.left; right: parent.right; top: parent.top; bottom: bottomSpace.top}
            plugin: Plugin {
                name: "here"
                PluginParameter { name: "app_id"; value: "NLB3kBjI4bS0nlcgpIUV" }
                PluginParameter { name: "app_code"; value: "El1Ls8obCfym7mnQCOjk5Q" }
                PluginParameter { name: "proxy"; value: "system" }
            }
            MapQuickItem {
                id:currentPosition
                sourceItem: Item{
                    width: currentPositionIcon.width
                    height: currentPositionIcon.height
                    Image{
                        id:currentPositionIcon
                        source: "image://theme/icon-m-person"
                        visible: false
                    }
                    ColorOverlay{
                        anchors.fill: currentPositionIcon
                        source: currentPositionIcon
                        color: 'red'
                    }
                }
                coordinate: uncertaintyCircle.center
                visible: uncertaintyCircle.visible
                anchorPoint.x: currentPosition.width/2
                anchorPoint.y: currentPosition.height/2
            }
            Component.onCompleted: {
                //map.center = QtPositioning.coordinate(39.775, -3.845);
                map.center = src.position.coordinate
                //console.log("==> "+src.horizontalAccuracy);
                map.zoomLevel = 15;
            }
            MouseArea {
                id:mapMouseArea
                anchors.fill: parent
                onPressAndHold: {
                    if (closeZone.visible === false){
                        closeZone.visible = true
                    }
                    closeZone.center = map.toCoordinate(Qt.point(mouseX,mouseY))
                    map.center = closeZone.center
                    //console.log("Clicked! on "+mouseX+", "+mouseY)
                    //console.log("Which is"+ map.toCoordinate(Qt.point(mouseX,mouseY)))
                }
            }
        }
        Item{
            id: bottomSpace
            anchors.bottom: parent.bottom
            width: parent.width
            height: doneButton.height+Theme.itemSizeExtraSmall/5
            Button{
                id: doneButton
                anchors{horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: Theme.itemSizeExtraSmall/10}
                text: qsTr("Go back")
                onClicked: {
                    mapPage.backNavigation = true
                    pageStack.navigateBack()}
            }
        }
    }
}
