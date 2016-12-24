
from suds.client import Client
import uuid


def getTiemposLlegada(parada)
    con = Client("http://www.infobustussam.com:9005/InfoTusWS/services/InfoTus?wsdl", username="infotus-usermobile", password="2infotus0user1mobile2", headers={"deviceid":str(uuid.uuid4())})
    salida = con.service.getTiemposNodo(parada)
    print(salida)
    return salida
