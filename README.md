# MedsReminder - Progetto Mobile Development

![A small preview](images/preview.png)
### Autore/i:
- Marzona Eugenio - 128623

## Una breve descrizione
Questo repository contiene il sorgente dell'applicazione flutter sviluppata per il corso di "Mobile Development" dell'Università degli Studi di Udine.

Si tratta di una semplice agenda digitale per tenere traccia di farmaci da assumere ed appuntamenti medici.

## Compilare il progetto
L'applicazione è stata testata (in modo non estensivo) su un dispositivo con Andriod 10 (Le eco le max 2).

Per la compilazione ho utilizzato la versione 2.8.0 di flutter, in quanto ho riscontrato problemi di compatibilità con alcuni dei pacchetti utilizzati con l'ultima vesione disponibile per macOS.

L'apk già compilato è disponibile nella sezione _Releases_ di questo repository.

Per evitare problemi in fase di compilazione consiglio in ogni caso di effettuare un cleanup del progetto ...
    
    cd ./medsreminder
    flutter clean
    flutter pub cache repair
    flutter pub get
    flutter build apk

**Nota:** L'unica versione testata è quella Android

## Pacchetti utilizzati
Per lo sviluppo di alcune delle feature dell'applicazione sono stati utlizzati i seguenti pacchetti:
* `path/path_provider` -> Per l'accesso semplificato ai file locali
* `sqflite` -> Persistenza (locale) dei dati inseriti dall'utente
* `provider` -> Utilizzato in maniera estensiva per gestire inserimento, modifica e cancellazione di farmaci, reminder e appuntamenti, per la gestione delle preferenze globali, per la costruzione dinamica delle schermate dell'applicazione ecc...
* `table_calendar` -> Widget 'calendario' utilizzato nella schermata omonima.
* `datetime_picker_formfield` -> Widget date picker utilizzato nei form.
* `flutter_local_notifications` -> Per lo scheduling delle notifiche e reminder giornalieri.
* `cron` -> Per 'resettare' i reminder di assunzione farmaci al termine della giornata.
* `google_fonts`
* `shared_preferences`

## Feature implementate
La versione dell'applicazione presente su questo repository include tutte le feature a priorità alta e gran parte delle feature a priorità media previste in fase di **Envision**.

Fra le feature che, per mancanza di tempo o difficoltà tecniche nell'implementazione, ho lasciato per un eventuale ulteriore sviluppo dell'applicazione compaiono:
- Supporto multilingua e multilocale
- Integrazione con i calendari di sistema (Android, Outlook ecc...)
- Notifiche ricorrenti anche per gli appuntamenti
- Protezione con password dei dati dell'utente
- Modalità ad alto contrasto ed alta leggibilità
- Integrazione con google maps

## Differenze rispetto ai prototipi
Il "layout" delle schermate dell'applicazione, al netto delle scelte di presentazione estetica effettuate, ricalca in maniera piuttosto fedele il prototipo interattivo realizzato per la **Parte 2** del progetto.

A seguito della valutazione effettuata con utenti ho tuttavia:
- rivisto etichette e hint text dei campi testuali dei form
- cercato di fare il possibile per rendere più chiaro l'indicatore di 'evento fissato' all'interno del widget calendario

Nelle sezioni sottostanti mi soffermo brevemente sulle schermate relative a feature dell'applicazione che non compaiono o sono solo abbozzate all'interno degli sketch e prototipi.

### Notifiche Locali
Le notifiche che possono essere inviate dall'applicazione sono di due tipi: notifiche di assunzione di farmaci, che si ripetono giornalmente, e notifiche di appuntamento, che vengono inviate all'utente una sola volta.

![Local Notification](/images/notifications.png)

Date le limitazioni del plugin utilizzato per la gestione delle notifiche, all'utente vengono presentate solamente le informazioni essenziali.

Una volta ricevuta la notifica, selezionandola, vengono eseguite le seguenti azioni:
- **Per i Farmaci:** L'applicazione viene aperta e all'utente viene mostrato un dialog con una serie di pulsanti per indicare se ha assunto o meno la dose di farmaco indicata
- **Per gli Appuntamenti:** L'applicazione rimanda l'utente alla schermata dedicata all'appuntamento specifico

**Nota:** Nel caso in cui l'utente segnali manualmente l'assunzione del farmaco dalla schermata home prima dell'orario dell'appuntamento, la notifica viene automaticamente spostata al giorno successivo.

### Pulsante di inserimento farmaci/appuntamenti
Il pulsante "Add", per l'inserimento di farmaci e appuntamenti è presente in tutte le schermate principali dell'applicazione esclusa quella "more".

Nel caso in cui questo sia premuto dalla schermata "Calendario" o "Farmaci", viene aperto direttamente il form per l'inserimento rispettivamente di appuntamenti e medicinali.

![Local Notification](/images/add.png)

Premendolo dalla "Home" viene invece mostrato un dialog che permette di scegliere quale dei due si desidera inserire.

### Form e Pickers
I due form sono stati ridotti a due pagine per ognuno, eliminando la possibilità di inserire un promemoria per ricordare all'utente che la sua scorta di farmaci si sta esaurendo.

Nel caso in cui l'utente richieda la modifica di un farmaco o appuntamento, verrà riportato allo stesso form utilizzato per l'inserimento e vedrà i campi già compilati.

![Local Notification](/images/pickers.png)

Per la selezione di date e orari sono stati utilizzati i 'picker' built-in di flutter, mentre per la selezione dell'immagine associata ai farmaci ho realizzato un dialog che permette all'utente di scegliere fra un set limitato di icone.

## Risorse utili
La documentazione del pacchetto **flutter_local_notifications** è di difficile lettura e gli esempi disponibili sono poco chiari. Questo articolo di _Medium_ spiega come effettuarne il setup:

- https://medium.com/flutter-community/local-notifications-in-flutter-746eb1d606c6

Alcuni spunti per lavorare con form con campi dinamici:
- https://yatindeokar33.medium.com/working-with-dynamic-multi-form-in-flutter-with-validation-73ed03833874

Lavorare con database in flutter (SQLite/Firebase):
- https://www.tutorialspoint.com/flutter/flutter_database_concepts.htm

Concetti base di _Material Design_:
- https://www.youtube.com/watch?v=stoJpMeS5aY

## Asset
I font utilizzati provengono dalla collezione [Google Fonts](https://fonts.google.com/) e sono sotto Licenze Open.

Le icone provengono dalla collezione [Font Awesome 3](https://fontawesome.com/icons) (licenza SIL) e dal pacchetto di icone material di flutter.

Le immagini utilizzate sono state realizzate da me per questo progetto.

## Stumenti utilizzati
- **VS Code**
- **Affinity Designer** e **Affinity Photo**

## Problemi noti
- <del>Il toggle per la modalità scura presente nel menù opzioni non aggiorna sempre lo stato correttamente</del>