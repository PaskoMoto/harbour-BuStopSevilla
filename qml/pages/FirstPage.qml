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
    property var var_tiempos_llegada: ""
    property bool modules_unloaded: true
    property var searchStop: "0"
    function pushAskButton(){
        pythonMain.ask();
        var_tiempos_llegada = [];
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu{
            MenuItem{
                text: qsTr("About")
                onClicked: {
                    pageStack.push("About.qml")
                }
            }
        }
        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Arrival times")
            }
//            Label {
//                height: Theme.itemSizeMedium
//                width: parent.width
//                anchors.horizontalCenter: parent.horizontalCenter
////                        text: "Estimation:"+var_tiempos_llegada[index][1]+", "+var_tiempos_llegada[index][2]
//                text: var_tiempos_llegada
//                color: Theme.secondaryHighlightColor
//                font.pixelSize: Theme.fontSizeSmall
//            }
            Repeater{
                id:timesList
                model: var_tiempos_llegada.length
                Column{
                    width: column.width
                    Label {
                        height: Theme.itemSizeExtraSmall/2
                        width: Theme.itemSizeMedium
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Theme.itemSizeExtraSmall/10
                        text: "Line: "+var_tiempos_llegada[index][0]
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                    Label {
                        height: Theme.itemSizeExtraSmall/2
                        width: parent.width*0.8
                        anchors.right: parent.right
                        text: "Estimation: "+var_tiempos_llegada[index][1]+" ("+var_tiempos_llegada[index][2]+" m), "+var_tiempos_llegada[index][3]+" ("+var_tiempos_llegada[index][4]+" m)"
//                        text: var_tiempos_llegada
                        color: Theme.secondaryColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }
            }
//            BusyIndicator{
//                running: if (var_tiempos_llegada === []){
//                             return false
//                         }
//                         else if(var_tiempos_llegada === [0]){
//                             return true
//                         }
//                         else{
//                             return false
//                         }
//            }
            TextField{
                id:busStopCode
                width: parent.width*0.5
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: qsTr("Ask for a bus stop code")
                label:qsTr("Bus stop code")
                inputMethodHints: Qt.ImhDigitsOnly
                text: if(searchStop != "0"){
                          return searchStop
                      }
                      else{
                          return ""
                      }
            }

            Item{
                width: parent.width*0.9
                height: Theme.itemSizeMedium
//                anchors.top: busStopCode.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                Button{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    text: qsTr("Pick stop!")
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("LinesPage.qml"))
                    }
                }
                Button{
                    id: askButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
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
            }
        }
    }
    Python{
        id:pythonMain
        Component.onCompleted: {
            if(modules_unloaded){
                addImportPath(Qt.resolvedUrl('.'));
                importModule('api', function () {});
                modules_unloaded = false;
                console.log("===> Modules loaded!")
            }
            if(searchStop > 0){
                pushAskButton();
            }

            setHandler('TiemposLlegada',function(TiemposLlegada){
                var_tiempos_llegada = TiemposLlegada;
                console.log("===> Got some info!!")
            });
        }
//        function ask(){
//            call('api.getTiemposLlegada', function() {});
//        }
        function ask(){
            call('api.getTiemposLlegada', [busStopCode.text] , function(parada) {});
            console.log("Details requested.")
        }

        onReceived:
            {
                // All the stuff you send, not assigned to a 'setHandler', will be shown here:
                console.log('got message from python: ' + data);
            }
    }
}

