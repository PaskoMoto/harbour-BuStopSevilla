import pyotherside
from suds.client import Client
import uuid
from datetime import datetime


def getTiemposLlegada(parada = 154):
    if type(parada) != type(1):
        parada = int(parada)
    con = Client("http://www.infobustussam.com:9005/InfoTusWS/services/InfoTus?wsdl", username="infotus-usermobile", password="2infotus0user1mobile2", headers={"deviceid":str(uuid.uuid4())})
    result = con.service.getTiemposNodo(parada)
    output = []
    fastest = 200
    for item in result.lineasCoincidentes.tiempoLinea:
        line = [item.label]
        line.append(str(abs(item.estimacion1.minutos)))
        line.append(str(abs(item.estimacion1.metros)))
        line.append(str(abs(item.estimacion2.minutos)))
        line.append(str(abs(item.estimacion2.metros)))
        if abs(item.estimacion1.minutos) <= fastest:
            fastest = abs(item.estimacion1.minutos) 
            output.insert(0,line)
        else:
            output.append(line)
    
    pyotherside.send('TiemposLlegada',output)
    print(output)
    return 1

def getCardBalance(cardCode):
    con = Client("http://www.infobustussam.com:9005/InfoTusWS/services/InfoTus?wsdl", username="infotus-usermobile", password="2infotus0user1mobile2", headers={"deviceid":str(uuid.uuid4())})
    r = con.service.getCardState(cardCode,datetime.today().__format__("%d/%m/%Y"))
    if r.chipNumber != -1:
        output = [str(r.chipNumber), r.passName, r.expiryDate, r.moneyCredit, r.tripsCredit]
    else:
        output = [None]
    pyotherside.send('CardBalance',output)
    print(output)
    return 1
