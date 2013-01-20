# HTerm

[HTerm](http://www.der-hammer.info/terminal/) ist ein Drittanbieter-Hyperterminal-Tool, welches wir für unser Projekt verwendet haben.

### Automatische Konfiguration
Wenn *HTerm.exe* im gleichen Verzeichnis wie das Config-File *hterm.cfg* platziert wird, sollte beim Starten automatisch die richtige Konfiguration geladen werden.


### Manuelle Konfiguration
Folgende Einstellungen sind optimal für das Projekt "Primfaktorzerlegung":

- Baud: **9600** (Oder wie in *uart_settings.s* eingestellt)
- Data: **8** (Oder wie in *uart_settings.s* eingestellt)
- Stop: **1**  (Oder wie in *uart_settings.s* eingestellt)
- Parity: **None** (Oder wie in *uart_settings.s* eingestellt)
- Newline at: **LF**
- Show newline characters: **false**
- Send on enter: **CR-LF**