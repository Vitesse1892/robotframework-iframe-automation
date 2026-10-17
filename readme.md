# Robot Framework iFrame Automation

## Overzicht

Dit project bevat een geautomatiseerde UI-testsuite voor het testen van iFrames binnen de [Playwright Automation Practice](https://www.playwrightautomation.com/practice.html#section-frame-counting) applicatie.

De testsuite is ontwikkeld met **Robot Framework** en de **Browser Library (Playwright)**.

Het doel van dit project was niet alleen het automatiseren van verschillende iFrame-scenario's, maar ook het ontwikkelen van een onderhoudbaar, herbruikbaar en schaalbaar testframework.

De focus ligt specifiek op het automatiseren van functionaliteit waarbij elementen zich binnen verschillende documentcontexten bevinden, zoals:

- Meerdere onafhankelijke iFrames
- Formulieren binnen iFrames
- Geneste iFrames (nested frames)
- Navigatie tussen verschillende iFrame-contexten
- Dynamische validatie van gegevens binnen iFrames

Hierbij is bewust gekozen voor een componentgerichte architectuur, waarbij testlogica, testdata en technische implementatie van elkaar zijn gescheiden.

---

## Architectuur

Het framework is opgezet volgens een **componentgerichte architectuur**, geïnspireerd op het Page Object Model (POM).

In plaats van volledige pagina's centraal te stellen, zijn afzonderlijke iFrame-componenten ondergebracht in eigen resourcebestanden.

Deze aanpak sluit aan bij de structuur van de applicatie, waarin verschillende iFrames onafhankelijk van elkaar functioneren.

### Projectstructuur

```text
robotframework-iframe-automation/
│
├── resources/
│   ├── components/
│   │   ├── iframe/
│   │   │   ├── advanced_nested_frame.resource
│   │   │   ├── frame_counting.resource
│   │   │   └── payment_gateway.resource
│   │   │
│   │   └── common.resource
│   │
│   └── testdata/
│       ├── advanced_nested_frame.resource
│       ├── travel_dashboard.resource
│       └── payment_gateway.resource
│
├── tests/
│   └── iframe/
│       ├── advanced_nested_frame.robot
│       ├── frame_counting.robot
│       └── payment_gateway.robot
│
├── results/
├── .gitignore
├── readme.md
└── requirements.txt
```

### Componenten

Voor iedere iFrame-functionaliteit is een afzonderlijk resourcebestand aangemaakt.

Voorbeelden:

- `frame_counting.resource`
- `payment_gateway.resource`
- `advanced_nested_frame.resource`

Deze bestanden bevatten:

- Component-specifieke locators
- Herbruikbare interacties met elementen
- Logica voor het uitlezen van gegevens
- Validaties van de betreffende component
- Navigatie door iFrame-contexten

Hierdoor zijn de verantwoordelijkheden duidelijk gescheiden.

Wanneer bijvoorbeeld een locator binnen het Payment Gateway Frame verandert, hoeft deze slechts op één centrale plaats aangepast te worden.

---

## Scheiding van testdata en testlogica

Alle testdata is ondergebracht in afzonderlijke resourcebestanden binnen `resources/testdata/`.

Hierdoor bevatten de testscenario's voornamelijk functionele stappen, terwijl de verwachte waarden centraal worden beheerd.

### Travel Dashboard

Voor het controleren van vluchtgegevens wordt gebruikgemaakt van dictionaries.

Voorbeeld:

```robotframework
&{FLIGHT_PW101}
...    route=London → New York
...    status=On Time

&{FLIGHT_PW202}
...    route=Dubai → Singapore
...    status=Delayed

&{EXPECTED_FLIGHTS}
...    PW101=${FLIGHT_PW101}
...    PW202=${FLIGHT_PW202}
```

Op dezelfde manier worden de verwachte hotelgegevens beheerd.

De test vergelijkt de daadwerkelijk uitgelezen gegevens vervolgens met de verwachte dataset.

### Payment Gateway

Voor de betaalfunctionaliteit zijn verschillende datasets gedefinieerd.

Deze bevatten onder andere:

- Naam van de kaarthouder
- Kaartnummer
- Vervaldatum
- CVV
- Verwachte betaalstatus
- Verwacht saldo
- Verwacht resultaat

Dezelfde testlogica kan hierdoor worden gebruikt voor verschillende betaaluitkomsten.

### Travel Enquiry

Voor het Travel Enquiry Form wordt testdata dynamisch gegenereerd.

Iedere testuitvoering kan daardoor een nieuwe combinatie bevatten van:

- Naam
- E-mailadres
- Travel preference

De travel preference wordt willekeurig geselecteerd uit de beschikbare opties:

- Business
- Family
- Solo Traveller
- Adventure

Hierdoor wordt voorkomen dat de test uitsluitend afhankelijk is van één vaste combinatie van invoergegevens.

---

## Dynamische validaties

Waar mogelijk zijn validaties dynamisch opgezet.

In plaats van uitsluitend individuele elementen of vaste waarden te controleren, worden gegevens rechtstreeks uit de applicatie uitgelezen en vergeleken met de verwachte testdata.

### Frame Counting

Binnen het Travel Dashboard wordt het werkelijke aantal iFrames bepaald.

Dit aantal wordt vergeleken met de teller die de applicatie zelf toont.

Hierdoor wordt niet uitgegaan van een hardcoded aantal frames.

### Vluchtgegevens

De tests lezen dynamisch de beschikbare vluchtregels uit het Flight Status Frame.

Per vlucht worden de volgende gegevens verzameld:

- Vluchtnummer
- Route
- Status

Deze gegevens worden samengevoegd in een dictionary.

Vervolgens wordt de volledige dictionary vergeleken met de verwachte testdata.

```robotframework
${actual_flights}=    Get Flight Data

Dictionaries Should Be Equal
...    ${actual_flights}
...    ${EXPECTED_FLIGHTS}
```

Hierdoor worden niet alleen afzonderlijke waarden gecontroleerd, maar ook de onderlinge samenhang tussen vluchtnummer, route en status.

### Hotelgegevens

Dezelfde aanpak wordt toegepast op het Hotel Availability Frame.

Per hotel worden de naam en het aantal beschikbare kamers uitgelezen.

```robotframework
${actual_hotels}=    Get Hotel Data

Dictionaries Should Be Equal
...    ${actual_hotels}
...    ${EXPECTED_HOTELS}
```

Door volledige datasets te vergelijken, worden ontbrekende, onverwachte of afwijkende gegevens zichtbaar.

---

## Automatisering van iFrames

Het belangrijkste technische onderdeel van dit project is het werken met verschillende iFrame-contexten.

Een iFrame bevat een eigen document. Elementen binnen een iFrame kunnen daarom niet rechtstreeks worden benaderd alsof ze onderdeel zijn van het hoofddocument.

De Browser Library biedt hiervoor ondersteuning via de `>>>`-syntaxis.

### Element binnen een iFrame

Voorbeeld:

```robotframework
Fill Text
...    ${PAYMENT_FRAME} >>> ${CARD_HOLDER}
...    ${payment}[holder]
```

Hiermee wordt eerst de juiste iFrame-context benaderd en vervolgens het betreffende invoerveld.

### Geneste iFrames

Bij het Travel Enquiry Form bevindt de Travel Preference-functionaliteit zich binnen een iFrame dat zelf onderdeel is van een ander iFrame.

Hiervoor wordt een keten van iFrame-selectors gebruikt.

```robotframework
Click
...    ${FEEDBACK_FRAME} >>> ${TRAVEL_PREFS_FRAME} >>> ${selector}
```

Hierdoor kan rechtstreeks met elementen in een genest iFrame worden geïnteracteerd.

### Wisselen tussen iFrames

Binnen het Frame Counting-scenario wordt ook gecontroleerd of gegevens consistent blijven wanneer achtereenvolgens verschillende iFrames worden benaderd.

De test leest bijvoorbeeld:

1. Vluchtgegevens uit het Flight Status Frame
2. Hotelgegevens uit het Hotel Availability Frame
3. Opnieuw vluchtgegevens uit het Flight Status Frame

Bij iedere stap worden de gegevens opnieuw gevalideerd.

Hiermee wordt aangetoond dat de automatisering correct met verschillende iFrame-contexten omgaat.

---

## Herbruikbare keywords

Technische UI-interacties zijn ondergebracht in herbruikbare keywords.

Voorbeelden:

```robotframework
Get Dashboard Frame Count
Get Flight Data
Get Hotel Data

Fill Payment Form
Submit Payment
Verify Payment Results

Fill Travel Enquiry Form
Select Travel Preference
Submit Travel Enquiry
Verify Travel Enquiry Success
```

Hierdoor beschrijven de testcases voornamelijk het gewenste gedrag.

### Voorbeeld: Payment Gateway

```robotframework
TC01 - Verify approved payment
    Fill Payment Form    ${PAYMENT_APPROVED}
    Submit Payment
    Verify Payment Results    ${PAYMENT_APPROVED}
```

De test bevat geen technische details over de individuele invoervelden of de gebruikte selectors.

Deze bevinden zich in het bijbehorende componentbestand.

Hetzelfde keyword kan vervolgens worden gebruikt voor andere datasets.

```robotframework
TC02 - Verify insufficient balance payment
    Fill Payment Form    ${PAYMENT_INSUFFICIENT}
    Submit Payment
    Verify Payment Results    ${PAYMENT_INSUFFICIENT}
```

Hierdoor kan een nieuw scenario worden toegevoegd zonder de bestaande implementatie van het formulier te dupliceren.

---

## Geïmplementeerde functionaliteit

### Frame Counting

- Controle van het werkelijke aantal iFrames
- Vergelijking met de weergegeven frameteller
- Dynamisch uitlezen van vluchtgegevens
- Validatie van vluchtnummers, routes en statussen
- Dynamisch uitlezen van hotelgegevens
- Validatie van hotelnamen en beschikbare kamers
- Controle van dataconsistentie bij het afwisselend benaderen van verschillende iFrames

### Payment Gateway Frame

- Invullen van betaalgegevens binnen een iFrame
- Verzenden van het betaalformulier
- Controle van een goedgekeurde betaling
- Controle van een betaling met onvoldoende saldo
- Controle van een betaling met een onbekend kaartnummer
- Validatie van de betaalstatus
- Validatie van het weergegeven saldo
- Validatie van het betaalresultaat

De verschillende betaaluitkomsten worden getest met dezelfde herbruikbare keywords en afzonderlijke datasets.

### Advanced Frame Handling — Nested Frames

- Dynamisch genereren van testgegevens
- Invullen van naam en e-mailadres in het parent frame
- Benaderen van een genest child frame
- Selecteren van een willekeurige travel preference
- Terugkeren naar functionaliteit in het parent frame
- Verzenden van het formulier
- Controleren van de succesmelding

Dit scenario demonstreert hoe een volledige gebruikersflow kan worden geautomatiseerd wanneer de benodigde elementen zich over meerdere documentcontexten bevinden.

---

## Ontwerpkeuzes

Tijdens de implementatie is bewust gekozen voor een aantal uitgangspunten.

### 1. Componentgerichte architectuur

De applicatie bestaat uit verschillende onafhankelijke iFrame-componenten.

Daarom is gekozen voor een structuur waarin iedere component zijn eigen resourcebestand heeft.

Dit maakt het framework overzichtelijk en zorgt ervoor dat wijzigingen lokaal kunnen worden doorgevoerd.

### 2. Herbruikbare keywords

Veelvoorkomende interacties zijn ondergebracht in afzonderlijke keywords.

Hierdoor kunnen dezelfde acties vanuit meerdere testscenario's worden aangeroepen.

Dit voorkomt duplicatie en vereenvoudigt het toevoegen van nieuwe tests.

### 3. Scheiding tussen testdata en testimplementatie

De verwachte gegevens staan los van de technische automatiseringslogica.

Hierdoor kunnen nieuwe datasets worden toegevoegd zonder de bestaande keywords aan te passen.

### 4. Dynamische controles

Waar mogelijk worden gegevens rechtstreeks uit de applicatie verzameld.

Dit maakt het mogelijk om volledige datasets te controleren in plaats van uitsluitend losse elementen.

### 5. Stabiele locators

Waar beschikbaar wordt gebruikgemaakt van `data-testid`-attributen.

Deze zijn doorgaans minder afhankelijk van visuele opmaak dan selectors die gebaseerd zijn op CSS-klassen of de positie van een element.

Voor onderdelen zonder `data-testid` worden selectors gebruikt die aansluiten op de beschikbare DOM-structuur.

### 6. Centrale browserfunctionaliteit

Algemene functionaliteit voor het openen en sluiten van de applicatie is ondergebracht in `common.resource`.

Hierdoor hoeft de browserinitialisatie niet voor iedere component opnieuw te worden geïmplementeerd.

### 7. Leesbare testscenario's

De testcases zijn bewust compact gehouden.

Een test beschrijft wat er wordt gecontroleerd, terwijl de componentbestanden bepalen hoe de interactie technisch wordt uitgevoerd.

Hierdoor blijft de testlogica begrijpelijk zonder dat kennis van alle onderliggende selectors noodzakelijk is.

---

## Schaalbaarheid en uitbreidbaarheid

De architectuur is ingericht om nieuwe functionaliteit met minimale aanpassingen toe te voegen.

### Nieuwe testscenario's

Een extra scenario voor een bestaande component kan doorgaans worden toegevoegd door:

1. Nieuwe testdata te definiëren wanneer dat nodig is.
2. De bestaande component-keywords te hergebruiken.
3. Een nieuwe testcase toe te voegen aan het bijbehorende `.robot`-bestand.

Bestaande testcases hoeven hiervoor niet aangepast te worden.

### Nieuwe componenten

Wanneer een nieuwe iFrame-functionaliteit wordt toegevoegd, kan hiervoor een afzonderlijk resourcebestand worden aangemaakt.

Bijvoorbeeld:

```text
resources/components/iframe/
└── new_frame_component.resource

resources/testdata/
└── new_frame_component.resource

tests/iframe/
└── new_frame_component.robot
```

Hierdoor blijft de bestaande projectstructuur behouden en groeit het framework op een consistente manier.

---

## Gebruikte technologieën

- **Robot Framework** — Testautomatiseringsframework
- **Robot Framework Browser Library** — Browserinteracties en UI-automatisering
- **Playwright** — Onderliggende browserautomatisering
- **Python** — Runtime en ondersteuning van het framework
- **Visual Studio Code** — Ontwikkelomgeving
- **Git** — Versiebeheer
- **JavaScript** — Console devtools

---

## Installatie en uitvoering

### 1. Repository clonen

```bash
git clone <repository-url>
cd robotframework-iframe-automation
```

### 2. Virtuele omgeving aanmaken

```bash
python -m venv .venv
```

### 3. Virtuele omgeving activeren

Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

### 4. Dependencies installeren

```bash
pip install -r requirements.txt
```

### 5. Browser Library initialiseren

```bash
rfbrowser init
```

### 6. Alle tests uitvoeren

```bash
robot tests/iframe
```

### 7. Een afzonderlijke testsuite uitvoeren

Bijvoorbeeld de Payment Gateway-tests:

```bash
robot tests/iframe/payment_gateway.robot
```

### Testresultaten

Robot Framework genereert standaard onder andere:

- `log.html` — Gedetailleerde uitvoeringslog
- `report.html` — Overzicht van de testresultaten
- `output.xml` — Machineleesbare testresultaten

Deze bestanden maken het mogelijk om testuitvoeringen te analyseren en eventuele fouten te onderzoeken.

---

## Mogelijke vervolgstappen

Wanneer dit framework verder wordt uitgebreid, zie ik onder andere de volgende verbeteringen:

- Automatisering van dynamisch geladen iFrames
- Uitbreiding met negatieve validatiescenario's
- Data-driven testuitvoering met test templates
- Integratie met CI/CD via GitHub Actions
- Parallelle testuitvoering
- Test tagging en filtering
- Uitgebreidere foutdiagnostiek en rapportages
- Cross-browser testuitvoering
- Verdere uitbreiding van de bestaande componenten

---

## Opmerking

Dit project is ontwikkeld als portfolio-opdracht, waarbij de nadruk bewust is gelegd op de technische uitdagingen van iFrame-automatisering en de kwaliteit van de testarchitectuur.

De functionele scope is beperkt gehouden, zodat er voldoende aandacht kon worden besteed aan:

- Een duidelijke scheiding van verantwoordelijkheden
- Herbruikbare componenten en keywords
- Dynamische validaties
- Onderhoudbare selectors
- Gestructureerd testdatabeheer
- Leesbare en uitbreidbare testscenario's

Het resultaat is een compacte maar uitbreidbare testsuite die laat zien hoe verschillende soorten iFrames met Robot Framework en Playwright op een gestructureerde manier kunnen worden geautomatiseerd.