# earthviewer
NetVisualizer (earthviewer) ist ein leistungsstarkes Network Monitoring &amp; Visualization Tool. Es kombiniert Echtzeit-Traffic-Analyse mit einer grafischen Traceroute, um Datenpfade geografisch darzustellen. Überwache Verbindungen, identifiziere Engpässe und visualisiere Hops – alles in einer intuitiven Oberfläche.
🌍 Geodaten-Setup
Dieses Tool nutzt die GeoLite2-Datenbank von MaxMind, um IP-Adressen geografisch zu visualisieren. Aufgrund der Lizenzbestimmungen sind diese Daten nicht direkt im Repository enthalten und müssen manuell hinzugefügt werden: 
Account erstellen: Registriere dich für einen kostenlosen Account bei MaxMind GeoLite2.
Download: Lade die aktuellsten Datenbank-Pakete (z.B. GeoLite2 City) im GZIP oder Zip-Format herunter.
Installation:
Erstelle im Hauptverzeichnis deines Programms einen Ordner namens Geodaten.
Entpacke alle Dateien aus dem Download direkt in diesen Ordner.
Stelle sicher, dass die .mmdb-Dateien (z.B. GeoLite2-City.mmdb) dort abgelegt sind. 
⚖️ Rechtlicher Hinweis
Dieses Produkt enthält GeoLite2-Daten von MaxMind, die unter https://www.maxmind.com verfügbar sind. 

🛡️ VirusTotal Integration
Für die Sicherheitsanalyse von IP-Adressen und Dateien benötigt das Tool einen API-Key von VirusTotal.
Key erhalten: Registriere dich kostenlos bei VirusTotal Community, um deinen persönlichen API-Key in deinem Profil zu finden.
Einrichten: Öffne die Datei settings.json im Hauptverzeichnis.
Eintragen: Ersetze den Platzhalter bei "api_key" durch deinen echten Schlüssel:
json
{
  "api_key": "DEIN_VIRUSTOTAL_KEY_HIER"
}


sudo python3 main.py
