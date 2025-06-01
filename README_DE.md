# GroceryApp - Full Stack iOS & Vapor Anwendung

Eine vollständige Full-Stack Einkaufslisten-Verwaltungsanwendung, entwickelt mit **SwiftUI** (iOS) und **Vapor** (serverseitiges Swift), die moderne Swift-Entwicklung über den gesamten Technologie-Stack demonstriert.

[🇺🇸 English Version](README.md)

## 📱 Projektübersicht

GroceryApp ist eine umfassende Einkaufslisten-Verwaltungsanwendung, die Benutzern ermöglicht:
- Sichere Registrierung und Authentifizierung
- Erstellen von benutzerdefinierten Lebensmittelkategorien mit Farbkodierung
- Hinzufügen und Verwalten von Lebensmitteln innerhalb von Kategorien
- Verfolgung von Preisen und Mengen
- Löschen von Artikeln und Kategorien mit Kaskadierungsoperationen

## 🏗️ Architektur

Dieses Projekt demonstriert eine moderne Full-Stack Swift-Architektur:

### Frontend (iOS App)
- **SwiftUI** für moderne deklarative Benutzeroberfläche
- **Observation** Framework für Zustandsverwaltung
- **Benutzerdefinierter HTTP Client** mit async/await Netzwerkoperationen
- **JWT Token-Authentifizierung**
- **Navigation Stack** mit programmatischer Weiterleitung

### Backend (Vapor Server)
- **Vapor 4** Web-Framework
- **PostgreSQL** Datenbank mit Fluent ORM
- **JWT-Authentifizierung** mit sicherer Token-Behandlung
- **RESTful API** Design
- **Datenbank-Migrationen** für Schema-Management

### Geteilte Komponenten
- **GroceryAppSharedDTO** Paket für typsichere Datenübertragungsobjekte
- Konsistente Modelle zwischen Client und Server

## 🔗 Repository-Links

- **Haupt iOS App**: *Aktuelles Repository*
- **Vapor Server**: [grocery-app-server](https://github.com/tyfnnn/grocery-app-server)
- **Geteilte DTOs**: [GroceryAppSharedDTO](https://github.com/tyfnnn/GroceryAppSharedDTO)

## 🚀 Erste Schritte

### Voraussetzungen
- Xcode 15+ mit Swift 6.0
- PostgreSQL Datenbank
- Vapor Toolbox (optional aber empfohlen)

### Backend-Setup
1. Server-Repository klonen:
   ```bash
   git clone https://github.com/tyfnnn/grocery-app-server.git
   cd grocery-app-server
   ```

2. PostgreSQL-Datenbank in `configure.swift` konfigurieren:
   ```swift
   let postgresConfig = SQLPostgresConfiguration(
       hostname: "localhost",
       username: "ihr_benutzername",
       password: "ihr_passwort",
       database: "grocerydb",
       tls: .prefer(try .init(configuration: .clientDefault))
   )
   ```

3. Migrationen ausführen und Server starten:
   ```bash
   swift run
   ```

### iOS App-Setup
1. Dieses Repository klonen
2. `GroceryApp.xcodeproj` in Xcode öffnen
3. Server-URL in `Constants.swift` bei Bedarf aktualisieren
4. Im Simulator oder auf dem Gerät erstellen und ausführen

## 📚 Wichtige Lernkonzepte

### Full-Stack Swift-Entwicklung
- **Gemeinsame Sprache**: Verwendung von Swift über den gesamten Stack eliminiert Kontextwechsel
- **Typsicherheit**: Geteilte DTOs gewährleisten Compile-Time-Sicherheit zwischen Client und Server
- **Code-Wiederverwendung**: Gemeinsame Geschäftslogik und Modelle können geteilt werden

### Moderne iOS-Entwicklung
- **SwiftUI & Observation**: Reaktive UI-Updates mit minimalem Boilerplate
- **Async/Await**: Moderne Nebenläufigkeit für Netzwerkoperationen
- **Navigation Stack**: Programmatische Navigation mit typsicherer Weiterleitung

### Serverseitiges Swift
- **Vapor Framework**: Produktionsbereites Web-Framework mit exzellenter Performance
- **Fluent ORM**: Typsichere Datenbankoperationen mit Migrationen
- **JWT-Authentifizierung**: Sichere zustandslose Authentifizierung

### Datenbankdesign
- **Relationale Modellierung**: Ordnungsgemäße Fremdschlüssel-Beziehungen und Constraints
- **Migrationssystem**: Versionskontrollierte Datenbank-Schema-Änderungen
- **Kaskadierungsoperationen**: Automatische Bereinigung verwandter Daten

## 🎯 Warum Custom Backend vs. BaaS?

Während Backend-as-a-Service (BaaS) Lösungen wie Firebase hervorragend für schnelles Prototyping sind, bieten benutzerdefinierte Backends mehrere Vorteile für Lern- und Produktionsanwendungen:

### **Lernvorteile**
- **Tiefes Verständnis**: Vollständiges Verständnis von Web-APIs, Datenbanken und Authentifizierung aufbauen
- **Problemlösungsfähigkeiten**: Lernen, serverseitige Performance zu debuggen und zu optimieren
- **Architekturwissen**: Verstehen, wie skalierbare, wartbare Systeme entworfen werden

### **Technische Vorteile**
- **Vollständige Kontrolle**: Komplette Kontrolle über Datenmodelle, Geschäftslogik und Performance-Optimierungen
- **Benutzerdefinierte Logik**: Implementierung komplexer Geschäftsregeln, die in BaaS schwierig oder unmöglich sein können
- **Datenbankflexibilität**: Optimales Datenbankdesign und Abfragen für Ihren spezifischen Anwendungsfall wählen
- **Performance**: Feinabstimmung von Abfragen, Caching und Serverkonfiguration für optimale Performance

### **Produktionsüberlegungen**
- **Kostenvorhersagbarkeit**: Vermeidung unerwarteter Skalierungskosten, die bei BaaS-Preismodellen üblich sind
- **Datenbesitz**: Vollständige Kontrolle über Ihre Daten ohne Vendor Lock-in
- **Compliance**: Einfacher, spezifische regulatorische Anforderungen zu erfüllen (DSGVO, HIPAA, etc.)
- **Integration**: Nahtlose Integration mit bestehenden Unternehmenssystemen und Drittanbieterdiensten

### **Langzeitvorteile**
- **Anbieterunabhängigkeit**: Kein Risiko von Serviceeinstellung oder erzwungenen Migrationen
- **Anpassung**: Unbegrenzte Möglichkeit, Funktionalität zu modifizieren und zu erweitern
- **Team-Fähigkeiten**: Aufbau von Expertise, die sich über Projekte und Technologien überträgt

## 🛠️ Technische Features

### Authentifizierung & Sicherheit
- JWT-basierte zustandslose Authentifizierung
- Passwort-Hashing mit bcrypt
- Sichere Token-Speicherung und -Validierung

### Datenbankoperationen
- CRUD-Operationen für Benutzer, Kategorien und Artikel
- Fremdschlüssel-Beziehungen mit Kaskadierung beim Löschen
- Datenbankmigrationen für Schema-Versionierung

### API-Design
- RESTful Endpunkte mit konsistenten Mustern
- Ordnungsgemäße HTTP-Statuscodes und Fehlerbehandlung
- Typsichere Request/Response-Modelle

### iOS-Architektur
- MVVM-Muster mit beobachtbaren View Models
- Dependency Injection mit SwiftUI Environment
- Benutzerdefinierter HTTP Client mit Fehlerbehandlung

## 📖 Bildungswert

Dieses Projekt dient als exzellente Studienressource für:
- **iOS-Entwickler**, die Backend-Entwicklung verstehen möchten
- **Full-Stack-Entwickler**, die das Swift-Ökosystem erkunden
- **Studenten**, die moderne App-Architekturmuster lernen
- **Teams**, die Swift für serverseitige Entwicklung in Betracht ziehen

Die Kombination aus gemeinsamer Sprache, Typsicherheit und modernen async-Mustern macht dies zu einem idealen Projekt zum Verständnis, wie produktionsqualitative Anwendungen von Grund auf erstellt werden.

## 🤝 Beitragen

Fühlen Sie sich frei, Issues zu eröffnen oder Pull Requests einzureichen, um die Anwendung oder Dokumentation zu verbessern. Dieses Projekt ist für das Lernen konzipiert, daher sind Fragen und Vorschläge immer willkommen!

## 📄 Lizenz

Dieses Projekt ist für Bildungszwecke verfügbar. Bitte beachten Sie die individuellen Repository-Lizenzen für spezifische Bedingungen.
