# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-BuStopSevilla

CONFIG += sailfishapp

SOURCES += src/harbour-BuStopSevilla.cpp

OTHER_FILES += qml/harbour-BuStopSevilla.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-BuStopSevilla.changes.in \
    rpm/harbour-BuStopSevilla.spec \
    rpm/harbour-BuStopSevilla.yaml \
    translations/*.ts \
    harbour-BuStopSevilla.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-BuStopSevilla-de.ts

DISTFILES += \
    qml/pages/api.py \
    qml/pages/suds/__pycache__/__init__.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/__init__.cpython-35.pyc \
    qml/pages/suds/__pycache__/argparser.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/argparser.cpython-35.pyc \
    qml/pages/suds/__pycache__/builder.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/builder.cpython-35.pyc \
    qml/pages/suds/__pycache__/cache.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/cache.cpython-35.pyc \
    qml/pages/suds/__pycache__/client.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/client.cpython-35.pyc \
    qml/pages/suds/__pycache__/metrics.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/metrics.cpython-35.pyc \
    qml/pages/suds/__pycache__/options.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/options.cpython-35.pyc \
    qml/pages/suds/__pycache__/plugin.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/plugin.cpython-35.pyc \
    qml/pages/suds/__pycache__/properties.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/properties.cpython-35.pyc \
    qml/pages/suds/__pycache__/reader.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/reader.cpython-35.pyc \
    qml/pages/suds/__pycache__/resolver.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/resolver.cpython-35.pyc \
    qml/pages/suds/__pycache__/servicedefinition.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/servicedefinition.cpython-35.pyc \
    qml/pages/suds/__pycache__/serviceproxy.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/serviceproxy.cpython-35.pyc \
    qml/pages/suds/__pycache__/soaparray.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/soaparray.cpython-35.pyc \
    qml/pages/suds/__pycache__/store.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/store.cpython-35.pyc \
    qml/pages/suds/__pycache__/sudsobject.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/sudsobject.cpython-35.pyc \
    qml/pages/suds/__pycache__/version.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/version.cpython-35.pyc \
    qml/pages/suds/__pycache__/wsdl.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/wsdl.cpython-35.pyc \
    qml/pages/suds/__pycache__/wsse.cpython-35.opt-1.pyc \
    qml/pages/suds/__pycache__/wsse.cpython-35.pyc \
    qml/pages/suds/bindings/__pycache__/__init__.cpython-35.opt-1.pyc \
    qml/pages/suds/bindings/__pycache__/__init__.cpython-35.pyc \
    qml/pages/suds/bindings/__pycache__/binding.cpython-35.opt-1.pyc \
    qml/pages/suds/bindings/__pycache__/binding.cpython-35.pyc \
    qml/pages/suds/bindings/__pycache__/document.cpython-35.opt-1.pyc \
    qml/pages/suds/bindings/__pycache__/document.cpython-35.pyc \
    qml/pages/suds/bindings/__pycache__/multiref.cpython-35.opt-1.pyc \
    qml/pages/suds/bindings/__pycache__/multiref.cpython-35.pyc \
    qml/pages/suds/bindings/__pycache__/rpc.cpython-35.opt-1.pyc \
    qml/pages/suds/bindings/__pycache__/rpc.cpython-35.pyc \
    qml/pages/suds/mx/__pycache__/__init__.cpython-35.opt-1.pyc \
    qml/pages/suds/mx/__pycache__/__init__.cpython-35.pyc \
    qml/pages/suds/mx/__pycache__/appender.cpython-35.opt-1.pyc \
    qml/pages/suds/mx/__pycache__/appender.cpython-35.pyc \
    qml/pages/suds/mx/__pycache__/basic.cpython-35.opt-1.pyc \
    qml/pages/suds/mx/__pycache__/basic.cpython-35.pyc \
    qml/pages/suds/mx/__pycache__/core.cpython-35.opt-1.pyc \
    qml/pages/suds/mx/__pycache__/core.cpython-35.pyc \
    qml/pages/suds/mx/__pycache__/encoded.cpython-35.opt-1.pyc \
    qml/pages/suds/mx/__pycache__/encoded.cpython-35.pyc \
    qml/pages/suds/mx/__pycache__/literal.cpython-35.opt-1.pyc \
    qml/pages/suds/mx/__pycache__/literal.cpython-35.pyc \
    qml/pages/suds/mx/__pycache__/typer.cpython-35.opt-1.pyc \
    qml/pages/suds/mx/__pycache__/typer.cpython-35.pyc \
    qml/pages/suds/sax/__pycache__/__init__.cpython-35.opt-1.pyc \
    qml/pages/suds/sax/__pycache__/__init__.cpython-35.pyc \
    qml/pages/suds/sax/__pycache__/attribute.cpython-35.opt-1.pyc \
    qml/pages/suds/sax/__pycache__/attribute.cpython-35.pyc \
    qml/pages/suds/sax/__pycache__/date.cpython-35.opt-1.pyc \
    qml/pages/suds/sax/__pycache__/date.cpython-35.pyc \
    qml/pages/suds/sax/__pycache__/document.cpython-35.opt-1.pyc \
    qml/pages/suds/sax/__pycache__/document.cpython-35.pyc \
    qml/pages/suds/sax/__pycache__/element.cpython-35.opt-1.pyc \
    qml/pages/suds/sax/__pycache__/element.cpython-35.pyc \
    qml/pages/suds/sax/__pycache__/enc.cpython-35.opt-1.pyc \
    qml/pages/suds/sax/__pycache__/enc.cpython-35.pyc \
    qml/pages/suds/sax/__pycache__/parser.cpython-35.opt-1.pyc \
    qml/pages/suds/sax/__pycache__/parser.cpython-35.pyc \
    qml/pages/suds/sax/__pycache__/text.cpython-35.opt-1.pyc \
    qml/pages/suds/sax/__pycache__/text.cpython-35.pyc \
    qml/pages/suds/transport/__pycache__/__init__.cpython-35.opt-1.pyc \
    qml/pages/suds/transport/__pycache__/__init__.cpython-35.pyc \
    qml/pages/suds/transport/__pycache__/http.cpython-35.opt-1.pyc \
    qml/pages/suds/transport/__pycache__/http.cpython-35.pyc \
    qml/pages/suds/transport/__pycache__/https.cpython-35.opt-1.pyc \
    qml/pages/suds/transport/__pycache__/https.cpython-35.pyc \
    qml/pages/suds/transport/__pycache__/options.cpython-35.opt-1.pyc \
    qml/pages/suds/transport/__pycache__/options.cpython-35.pyc \
    qml/pages/suds/umx/__pycache__/__init__.cpython-35.opt-1.pyc \
    qml/pages/suds/umx/__pycache__/__init__.cpython-35.pyc \
    qml/pages/suds/umx/__pycache__/attrlist.cpython-35.opt-1.pyc \
    qml/pages/suds/umx/__pycache__/attrlist.cpython-35.pyc \
    qml/pages/suds/umx/__pycache__/basic.cpython-35.opt-1.pyc \
    qml/pages/suds/umx/__pycache__/basic.cpython-35.pyc \
    qml/pages/suds/umx/__pycache__/core.cpython-35.opt-1.pyc \
    qml/pages/suds/umx/__pycache__/core.cpython-35.pyc \
    qml/pages/suds/umx/__pycache__/encoded.cpython-35.opt-1.pyc \
    qml/pages/suds/umx/__pycache__/encoded.cpython-35.pyc \
    qml/pages/suds/umx/__pycache__/typed.cpython-35.opt-1.pyc \
    qml/pages/suds/umx/__pycache__/typed.cpython-35.pyc \
    qml/pages/suds/xsd/__pycache__/__init__.cpython-35.opt-1.pyc \
    qml/pages/suds/xsd/__pycache__/__init__.cpython-35.pyc \
    qml/pages/suds/xsd/__pycache__/deplist.cpython-35.opt-1.pyc \
    qml/pages/suds/xsd/__pycache__/deplist.cpython-35.pyc \
    qml/pages/suds/xsd/__pycache__/doctor.cpython-35.opt-1.pyc \
    qml/pages/suds/xsd/__pycache__/doctor.cpython-35.pyc \
    qml/pages/suds/xsd/__pycache__/query.cpython-35.opt-1.pyc \
    qml/pages/suds/xsd/__pycache__/query.cpython-35.pyc \
    qml/pages/suds/xsd/__pycache__/schema.cpython-35.opt-1.pyc \
    qml/pages/suds/xsd/__pycache__/schema.cpython-35.pyc \
    qml/pages/suds/xsd/__pycache__/sxbase.cpython-35.opt-1.pyc \
    qml/pages/suds/xsd/__pycache__/sxbase.cpython-35.pyc \
    qml/pages/suds/xsd/__pycache__/sxbasic.cpython-35.opt-1.pyc \
    qml/pages/suds/xsd/__pycache__/sxbasic.cpython-35.pyc \
    qml/pages/suds/xsd/__pycache__/sxbuiltin.cpython-35.opt-1.pyc \
    qml/pages/suds/xsd/__pycache__/sxbuiltin.cpython-35.pyc \
    qml/pages/suds/bindings/__init__.py \
    qml/pages/suds/bindings/binding.py \
    qml/pages/suds/bindings/document.py \
    qml/pages/suds/bindings/multiref.py \
    qml/pages/suds/bindings/rpc.py \
    qml/pages/suds/mx/__init__.py \
    qml/pages/suds/mx/appender.py \
    qml/pages/suds/mx/basic.py \
    qml/pages/suds/mx/core.py \
    qml/pages/suds/mx/encoded.py \
    qml/pages/suds/mx/literal.py \
    qml/pages/suds/mx/typer.py \
    qml/pages/suds/sax/__init__.py \
    qml/pages/suds/sax/attribute.py \
    qml/pages/suds/sax/date.py \
    qml/pages/suds/sax/document.py \
    qml/pages/suds/sax/element.py \
    qml/pages/suds/sax/enc.py \
    qml/pages/suds/sax/parser.py \
    qml/pages/suds/sax/text.py \
    qml/pages/suds/transport/__init__.py \
    qml/pages/suds/transport/http.py \
    qml/pages/suds/transport/https.py \
    qml/pages/suds/transport/options.py \
    qml/pages/suds/umx/__init__.py \
    qml/pages/suds/umx/attrlist.py \
    qml/pages/suds/umx/basic.py \
    qml/pages/suds/umx/core.py \
    qml/pages/suds/umx/encoded.py \
    qml/pages/suds/umx/typed.py \
    qml/pages/suds/xsd/__init__.py \
    qml/pages/suds/xsd/deplist.py \
    qml/pages/suds/xsd/doctor.py \
    qml/pages/suds/xsd/query.py \
    qml/pages/suds/xsd/schema.py \
    qml/pages/suds/xsd/sxbase.py \
    qml/pages/suds/xsd/sxbasic.py \
    qml/pages/suds/xsd/sxbuiltin.py \
    qml/pages/suds/__init__.py \
    qml/pages/suds/argparser.py \
    qml/pages/suds/builder.py \
    qml/pages/suds/cache.py \
    qml/pages/suds/client.py \
    qml/pages/suds/metrics.py \
    qml/pages/suds/options.py \
    qml/pages/suds/plugin.py \
    qml/pages/suds/properties.py \
    qml/pages/suds/reader.py \
    qml/pages/suds/resolver.py \
    qml/pages/suds/servicedefinition.py \
    qml/pages/suds/serviceproxy.py \
    qml/pages/suds/soaparray.py \
    qml/pages/suds/store.py \
    qml/pages/suds/sudsobject.py \
    qml/pages/suds/version.py \
    qml/pages/suds/wsdl.py \
    qml/pages/suds/wsse.py \
    qml/pages/LinesPage.qml
