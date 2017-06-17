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

        width: parent.width
        SilicaFlickable{
            anchors{
                fill: parent
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                top: parent.top
            }
            PullDownMenu{
                MenuItem{
                    text: qsTr("About")
                    onClicked: {
                        pageStack.push("About.qml")
                    }
                }
            }
            PageHeader{
                id: header
                title: qsTr("BuStop Sevilla")
            }
            SilicaGridView{
                clip: true
                id: mainGrid
                cellHeight: Theme.itemSizeMedium*2.75
                cellWidth: Theme.itemSizeMedium*2.2
                width: Math.floor(parent.width/cellWidth)*cellWidth
                anchors{
                    horizontalCenter: parent.Center
                    left: parent.left
                    bottom: parent.bottom
                    top: parent.top
                    topMargin: Theme.itemSizeExtraSmall
                    leftMargin: (parent.width-width)/2
                }

            model: ListModel{
                ListElement{
                    title: qsTr("Bus stop")
                    icon: "qrc:///res/bus_stop.png"
                    move2: "FirstPage.qml"
                }
                ListElement{
                    title: "Stops map"
                    icon: "qrc:///res/map.png"
                    move2: "TBDPage.qml"
                }
                ListElement{
                    title: "Usual stops"
                    icon: "image://theme/icon-m-favorite"
                    move2: "TBDPage.qml"
                }
                ListElement{
                    title: "Nearest stops?"
                    icon: "image://theme/icon-m-whereami"
                    move2: "TBDPage.qml"
                }
                ListElement{
                    title: "Lines"
                    icon: "image://theme/icon-l-document"
                    move2: "LinesPage.qml"
                }
                ListElement{
                    title: "Check card balance"
                    icon: "image://theme/icon-l-mobile-network"
                    move2: "TBDPage.qml"
                }
            }
            delegate: BackgroundItem {
                height: mainGrid.cellHeight
                width: mainGrid.cellWidth
                onClicked: {
                    console.log("clicked!")
                    pageStack.push(move2)
                }
                Image {
                    anchors{
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: Theme.itemSizeExtraSmall/2
                    }
                    id: imageIcon
                    width: Theme.itemSizeExtraLarge
                    height: width
                    source: icon
                }
                Label{
                    width: parent.width*0.9
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    anchors{
                        horizontalCenter: parent.horizontalCenter
                        top: imageIcon.bottom
                        topMargin: Theme.itemSizeExtraSmall/5
                    }
                    text: title
                    color: Theme.primaryColor
                }
            }
            /*Python{
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
            pushAskButton(); // Develop hack
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
    }*/
        }
    }
}

