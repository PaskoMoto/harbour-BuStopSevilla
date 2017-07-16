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

CoverBackground {
    id: coverStopPage
    property string vars: current_page[1]
    property var time_data: var_tiempos_llegada
    onStatusChanged: populateStopData(var_tiempos_llegada)
    onTime_dataChanged: populateStopData(var_tiempos_llegada)
    Label{
        id: header
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: Theme.itemSizeExtraSmall/5
        }
        text: qsTr("Stop nº ")+vars
        font.bold: true
    }
    Column{
        width: parent.width*0.8
        anchors{
            top: header.bottom
            topMargin: Theme.itemSizeExtraSmall/5
            horizontalCenter: parent.horizontalCenter
            bottom: coverAction.top
        }
        Item{
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: Theme.itemSizeExtraSmall/2
            Label{
                id: line1
                anchors.left: parent.left
                text: ""
            }
            Label{
                id: time1a
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
                text: ""
            }
            Label{
                id: time1b
                anchors.right: parent.right
                color: Theme.secondaryColor
                text: ""
            }
        }
        Item{
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: Theme.itemSizeExtraSmall/2
            Label{
                id: line2
                anchors.left: parent.left
                text: ""
            }
            Label{
                id: time2a
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
                text: ""
            }
            Label{
                id: time2b
                anchors.right: parent.right
                color: Theme.secondaryColor
                text: ""
            }
        }
        Item{
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: Theme.itemSizeExtraSmall/2
            Label{
                id: line3
                anchors.left: parent.left
                text: ""
            }
            Label{
                id: time3a
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
                text: ""
            }
            Label{
                id: time3b
                anchors.right: parent.right
                color: Theme.secondaryColor
                text: ""
            }
        }
        Item{
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: Theme.itemSizeExtraSmall/2
            Label{
                id: line4
                anchors.left: parent.left
                text: ""
            }
            Label{
                id: time4a
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
                text: ""
            }
            Label{
                id: time4b
                anchors.right: parent.right
                color: Theme.secondaryColor
                text: ""
            }
        }
        Item{
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: Theme.itemSizeExtraSmall/2
            Label{
                id: line5
                anchors.left: parent.left
                text: ""
            }
            Label{
                id: time5a
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
                text: ""
            }
            Label{
                id: time5b
                anchors.right: parent.right
                color: Theme.secondaryColor
                text: ""
            }
        }
        Item{
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: Theme.itemSizeExtraSmall/2
            Label{
                id: line6
                anchors.left: parent.left
                text: ""
            }
            Label{
                id: time6a
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
                text: ""
            }
            Label{
                id: time6b
                anchors.right: parent.right
                color: Theme.secondaryColor
                text: ""
            }
        }
    }

    CoverActionList {
        id: coverAction
        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: refresh()
        }
    }
    function refresh(){
        pythonMain.ask(vars)
        line1.text = ""
        time1a.text = ""
        time1b.text = ""
        line2.text = ""
        time2a.text = ""
        time2b.text = ""
        line3.text = ""
        time3a.text = ""
        time3b.text = ""
        line4.text = ""
        time4a.text = ""
        time4b.text = ""
        line5.text = ""
        time5a.text = ""
        time5b.text = ""
        line6.text = ""
        time6a.text = ""
        time6b.text = ""
    }

    function populateStopData(mylist) {
        if (mylist.length > 0){
            line1.text = mylist[0][0]+":"
            time1a.text = mylist[0][1]+"'"
            time1b.text = mylist[0][3]+"'"
        }
        if (mylist.length > 1){
            line2.text = mylist[1][0]+":"
            time2a.text = mylist[1][1]+"'"
            time2b.text = mylist[1][3]+"'"
        }
        if (mylist.length > 2){
            line3.text = mylist[2][0]+":"
            time3a.text = mylist[2][1]+"'"
            time3b.text = mylist[2][3]+"'"
        }
        if (mylist.length > 3){
            line4.text = mylist[3][0]+":"
            time4a.text = mylist[3][1]+"'"
            time4b.text = mylist[3][3]+"'"
        }
        if (mylist.length > 4){
            line5.text = mylist[4][0]+":"
            time5a.text = mylist[4][1]+"'"
            time5b.text = mylist[4][3]+"'"
        }
        if (mylist.length > 5){
            line6.text = mylist[5][0]+":"
            time6a.text = mylist[5][1]+"'"
            time6b.text = mylist[5][3]+"'"
        }
        console.log(mylist.length)
    }
}
