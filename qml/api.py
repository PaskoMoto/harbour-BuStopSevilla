import pyotherside
from suds.client import Client
import uuid


def getTiemposLlegada(parada = 154):
    con = Client("http://www.infobustussam.com:9005/InfoTusWS/services/InfoTus?wsdl", username="infotus-usermobile", password="2infotus0user1mobile2", headers={"deviceid":str(uuid.uuid4())})
    result = con.service.getTiemposNodo(parada)
    output = []
    #test = ""
    for item in result.lineasCoincidentes.tiempoLinea:
        line = [item.label]
        line.append(str(abs(item.estimacion1.minutos)))
        line.append(str(abs(item.estimacion1.metros)))
        #test = str(abs(item.estimacion1.minutos))
        line.append(str(abs(item.estimacion2.minutos)))
        line.append(str(abs(item.estimacion2.metros)))
        output.append(line)
    
    pyotherside.send('TiemposLlegada',output)
    #pyotherside.send('TiemposLlegada',test)
    print(output)
    return 1
