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
import Sailfish.Silica 1.0

Page{
    id: page
    anchors.fill: parent
    PageHeader{
        title: qsTr("Select a line")
    }
    SilicaGridView {
        width: parent.width
        height: parent.height*0.9
        id:viewGrid
        Rectangle{
            anchors.fill: parent
            color: 'white'
            z: -1
        }

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        model: ListModel {
            ListElement { line: "01" }
            ListElement { line: "02" }
            ListElement { line: "03" }
            ListElement { line: "34" }
            ListElement { line: "06" }
            ListElement { line: "C1" }
            ListElement { line: "C2" }
            ListElement { line: "C3" }
            ListElement { line: "C4" }
            ListElement { line: "37" }
        }
        cellWidth: viewGrid.width/5
        cellHeight: cellWidth
        delegate: ListItem {
            contentHeight: viewGrid.cellHeight*0.8
            contentWidth: contentHeight
            Rectangle{
                anchors.fill: parent
                radius: width
                color: 'red'
                Label {
                    anchors.centerIn: parent
                    text: line
                    fontSizeMode: Theme.fontSizeHuge
                }
            }
            onClicked: {
                console.log("Pushed "+line)
            }
        }
    }
}
