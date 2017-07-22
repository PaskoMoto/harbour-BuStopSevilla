import pyotherside
import os
from hashlib import md5
from shutil import copyfile

def checkDB():
    path = os.path.join(os.getenv("HOME"),".local/share/harbour-bustopsevilla/harbour-bustopsevilla/QML/OfflineStorage/Databases/")
    source = '/usr/share/harbour-bustopsevilla/db'
    db_name = 'bustopsevillaDB'
    db_hash = hash(db_name)
    if os.path.isfile(os.path.join(path,db_hash+".ini")) and os.path.isfile(os.path.join(path,db_hash+".sqlite")):
        return 1
    else:
        if not os.path.exists(path):
            os.makedirs(path)
        copyfile(os.path.join(source,db_hash+".ini"),os.path.join(path,db_hash+".ini"))
        copyfile(os.path.join(source,db_hash+".sqlite"),os.path.join(path,db_hash+".sqlite"))
        return 1

def hash(my_string):
    m = md5()
    m.update(bytes(my_string,'utf-8'))
    return str(m.hexdigest())
