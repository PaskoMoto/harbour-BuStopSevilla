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
import "pages"
import "cover"

ApplicationWindow
{
    id: rootPage
    property bool modules_unloaded: true
    property var var_tiempos_llegada
    property var current_page
    initialPage: Component { FrontPage { } }
//    cover: Qt.resolvedUrl("cover/CoverStopPage.qml")
//    cover: Component { CoverStopPage { } }
    cover: if (current_page[0] === 'StopPage'){
    return Qt.resolvedUrl("cover/CoverStopPage.qml")
}
    else{
        return Qt.resolvedUrl("cover/CoverPage.qml")
    }

    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
    Python{
        id:pythonMain
        Component.onCompleted: {
            if(modules_unloaded){
                addImportPath(Qt.resolvedUrl('.'));
                importModule('api', function () {});
                importModule('utils', function () {});
                modules_unloaded = false;
                console.log("===> Modules loaded!")
            }
            checkDB();
            setHandler('TiemposLlegada',function(TiemposLlegada){
                            var_tiempos_llegada = TiemposLlegada;
                            console.log("===> Got some info!!")
                        });
        }
        function ask(stopCode){
            call('api.getTiemposLlegada', [stopCode] , function(parada) {});
            var_tiempos_llegada = []
            console.log("Details requested.")
        }
        function checkDB(){
            call('utils.checkDB',[],console.log("DB OK."))
        }

        onReceived:
        {
            // All the stuff you send, not assigned to a 'setHandler', will be shown here:
            console.log('Got message from python: ' + data);
        }
    }
}

