# Internationalization (i18n)

The application supports multiple languages using `react-i18next`.

## Supported Languages
- **English (en)** - Default
- **Portuguese (pt)**
- **Spanish (es)**

## Implementation Details
- **Library:** `i18next`, `react-i18next`, `i18next-browser-languagedetector`.
- **Configuration:** `src/i18n.ts`.
- **Translation Files:** Located in `src/locales/{lang}/translation.json`.
- **Language Selector:** A custom dropdown in the `Navbar` component allows users to switch languages. The selection is persisted (via browser language detector).

## How to Add a New Language
1. Create a new folder in `src/locales/` (e.g., `fr`).
2. Create `translation.json` inside that folder.
3. Import the new JSON in `src/i18n.ts`.
4. Add the new language to the `resources` object in `src/i18n.ts`.
5. Add the new option to the `languages` array in `src/components/Navbar.tsx`.

## Key Components
- **Navbar:** Contains the language switcher with visual indicators (red circle).
- **Hooks:** Components use the `useTranslation` hook to access translation keys.
