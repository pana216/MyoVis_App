

# Bachelorarbeit Medizininformatik
##### Eberhard Karls Universität Tübingen

#### "MyoVis - Entwicklung eines Systems zur Analyse und Visualisierung der Muskelaktivität beim Bankdrücken mithilfe von EMG-Sensoren." 31.10.2019

### Zusammenfassung

Das Bankdrücken ist eine beliebte Ubung im Krafttraining und Teil des Kraftdreikampfs. Diverse Studien haben gezeigt, dass durch die Art und Weise wie die Hantelstange gegriffen und bewegt wird, eine unterschiedliche Muskelaktivität registriert werden kann. Im Rahmen dieser Arbeit wurde deshalb ein System namens MyoVis entwickelt, welches das Ziel verfolgt, dem Benutzer durch einen Prozess zu begleiten, indem verschiedene Einstellungsmöglichkeiten in der Bewegungsausführung des Bankdrückens getestet werden. Es konnte gezeigt werden, dass verschiedene Einstellungen der Parameter unterschiedliche Ergebnisse in der Muskelaktivität liefern. Weiterhin kann eine Aussage darüber getroffen werden, welche der Einstellungen für den Athleten optimal sind.

### Funktionalität
Die MyoVis iOS App hat zwei Grundlegende Funktionen. Den eigentlichen Optimierungsprozess und die Visualisierung der vergangenen Optimierungen.
Eine neue Optimierung wird durch Eingabe der Benutzerdaten auf dem Startbildschirm gestartet. Die Historie kann durch Anklicken der Registerkarte “Datenbank“, in der unteren Navigationsleiste eingesehen werden. 

<p float="center">
    <img src="/Screenshots/screenshot_home.png" width="25%">
    <img src="/Screenshots/screenshot_db.png" width="25%">
    <img src="/Screenshots/screenshot_graph.png" width="25%">
</p>

Die Daten können, bei Einsicht der Datenbank, in eine CSV-Datei exportiert und genauer untersucht werden.
Das eingehende Signal wird am Myoware-Sensor während der Bewegung registriert und an den Mikrocontroller gesendet. Der Mikrocontroller erfasst die Signale aller vier Sensoren an den entsprechenden Pins und speichert sie in der Characteristic ab. Der Client ist mit dem Server verbunden und hat diese Characteristic abonniert, wodurch er alle 50 ms über den neuen Wert informiert wird. Beim Empfang des Signals wird der Wert an den jeweiligen View-Controller weitergeleitet. Dort wird der Graph aktualisiert und der Wert in der jeweiligen Stage unter dem User-Model gespeichert. Nach beenden der aktuellen Stage werden die Werte in der Cloud gespeichert.
Dieser Vorgang wird dabei über alle neun Stages fortgeführt. Am Ende der Optimierung werden alle Signale angefragt und das Ergebnis wird berechnet.
