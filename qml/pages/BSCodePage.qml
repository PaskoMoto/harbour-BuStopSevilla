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

import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: page
    property string var_tiempos_llegada: ""
    property bool modules_unloaded: true
    property string searchStop: "0"
    property bool testing_rectangles: false
    function pushAskButton(){
        pythonMain.ask(busStopCode.text);
        pageStack.replace("StopPage.qml", {current_stop: busStopCode.text})
    }
    SilicaFlickable {
        anchors.fill: parent
        PageHeader {
            id: header
            title: qsTr("Bus stop code")
        }
        Item{
            width: parent.width*0.95
            height: Theme.itemSizeMedium
            anchors{
                top: header.bottom
                topMargin: Theme.itemSizeExtraSmall
                horizontalCenter: parent.horizontalCenter
            }
            TextField{
                id:busStopCode
                width: Theme.itemSizeHuge*1.4
                anchors{
                    top: parent.top
                    topMargin: Theme.itemSizeExtraSmall/3.3
                }
                placeholderText: qsTr("Enter a bus stop code")
                focus: true
                label:qsTr("Bus stop code")
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.onClicked: pushAskButton();
                text: if(searchStop != "0"){
                          return searchStop
                      }
                      else{
                          return ""
                      }
                Rectangle{
                    visible: testing_rectangles
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "yellow"
                }
            }
            BackgroundItem{
                width: Theme.itemSizeExtraSmall
                height: width
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: Theme.itemSizeHuge*1.2
                }
                Image{
                    anchors.centerIn: parent
                    source: "image://theme/icon-m-clear"
                }
                onClicked: {
                    busStopCode.text = ''
                }
                Rectangle{
                    visible: testing_rectangles
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "blue"
                }
            }
            Button{
                id: askButton
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: Theme.itemSizeExtraSmall/2.8
                }
                width: Theme.itemSizeExtraLarge
                text: qsTr("Ask!")
                enabled: {
                    if (busStopCode.text.length > 0){
                        return true
                    }
                    else{
                        return false
                    }
                }

                onClicked: {
                    pushAskButton();
                }
            }
            Rectangle{
                visible: testing_rectangles
                anchors.fill: parent
                color: "transparent"
                border.color: "green"
            }
        }
    }
    Component.onCompleted: {
        rootPage.current_page = ['BSCodePage']
    }
}
