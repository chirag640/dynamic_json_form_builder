# Changelog

All notable changes to this project will be documented in this file.

## [1.2.1] - 2025
- Added Example file which contains all the feilds 

## [1.2.0] - 2025
- Added new built-in field types: slider/range, rating, and color picker!
- Slider field supports min/max values, divisions, labels, and custom prefix/suffix.
- Rating field supports half-ratings, custom max rating, star size, and label descriptions.
- Color field supports color picker with preset colors and hex value display.
- Updated examples and JSON assets to showcase new field types.
- Enhanced field factory to handle new field types.
- Ready for production use with comprehensive field type support.

## [1.1.0] - 2025
- Major update: Publish-ready release!
- Added support for field grouping/sections with optional titles, descriptions, collapsible/expandable sections, and nested sections.
- Enhanced styling: Card-based sections, improved spacing, responsive design, and better theming.
- Simplified usage: Users can now provide JSON config (Map, string, or asset file) for form generation.
- Added factory methods: `JsonFormBuilder.fromJsonString()` and `JsonFormBuilder.fromAsset()`.
- Improved README with comprehensive documentation and examples.
- Updated example and asset files for easy onboarding.
- Updated pubspec.yaml to include assets.
- Bug fixes and code cleanup for publish.

## [1.0.1] - 2025
- Fixed documentation and analysis warnings.
- Improved API docs and example.

## [1.0.0] - 2025
- Initial release of `dynamic_json_form_builder`.
- Build dynamic, JSON-driven forms in Flutter with:
  - All major field types (text, dropdown, date, checkbox, radio, multi-select, file upload)
  - Custom theming (light/dark/custom)
  - Synchronous & asynchronous validation
  - Conditional logic (show/hide fields)
  - Custom user-defined fields
  - Responsive design (MediaQuery, AutoSizeText)
  - Placeholder/hint support
  - Label placement and section/group support
  - Extensible architecture for new field types
  - Platform support: Android, iOS, Web, Windows, macOS, Linux

---

<!--
## [Unreleased]
- Add new features and bugfixes here for the next version.
-->